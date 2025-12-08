// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class TutorialController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var slideViews: [TutorialSlideView] = []
    private let imageNames: [String]
    private var pageBeforeRotation: Int = 0

    init(slug: String) {
        self.imageNames = Self.discoverImages(for: slug)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // No vertical scrolling
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.delegate = self

        view.addSubview(scrollView)
        view.addSubview(pageControl)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),

            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 40)
        ])

        pageControl.numberOfPages = imageNames.count
        setupSlides()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Store current page before rotation
        if scrollView.bounds.width > 0 {
            pageBeforeRotation = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = view.bounds.width
        let height = scrollView.bounds.height

        for (index, slideView) in slideViews.enumerated() {
            let x = CGFloat(index) * width
            slideView.frame = CGRect(x: x, y: 0, width: width, height: height)
        }

        scrollView.contentSize = CGSize(width: width * CGFloat(slideViews.count), height: height)

        // Snap to the stored page to prevent being stuck between pages during rotation
        let targetOffset = CGFloat(pageBeforeRotation) * width
        scrollView.setContentOffset(CGPoint(x: targetOffset, y: 0), animated: false)
        setPageToPageControl()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPageToPageControl()
    }
}

// MARK: - Private

extension TutorialController {
    private static func discoverImages(for slug: String) -> [String] {
        guard let bundlePath = Bundle.main.resourcePath else {
            return []
        }
        
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(atPath: bundlePath) else {
            return []
        }
        
        let prefix = "tutorial-\(slug)-"
        return files
            .filter { $0.hasPrefix(prefix) && $0.hasSuffix(".jpg") }
            .sorted()
    }
    
    private func setPageToPageControl() {
        guard scrollView.bounds.width > 0 else { return }
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }

    private func setupSlides() {
        for (index, name) in imageNames.enumerated() {
            let slideView = TutorialSlideView(imageName: name, index: index)
            scrollView.addSubview(slideView)
            slideViews.append(slideView)
        }
    }
}
