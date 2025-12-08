// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class TutorialController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []

    private let imageNames = [
        "tutorial-ipad-01.jpg",
        "tutorial-ipad-02.jpg",
        "tutorial-ipad-03.jpg"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
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

    private func setupSlides() {
        for name in imageNames {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = view.bounds.width
        let height = scrollView.bounds.height
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(
                x: CGFloat(index) * width,
                y: 0,
                width: width,
                height: height
            )
        }

        scrollView.contentSize = CGSize(
            width: width * CGFloat(imageViews.count),
            height: height
        )
        
        // Prevent vertical scrolling
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }
}
