// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class TutorialController: UIViewController, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()

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
        for (index, name) in imageNames.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            imageView.frame = CGRect(
                x: CGFloat(index) * view.bounds.width,
                y: 0,
                width: view.bounds.width,
                height: scrollView.bounds.height
            )

            scrollView.addSubview(imageView)
        }

        scrollView.contentSize = CGSize(
            width: view.bounds.width * CGFloat(imageNames.count),
            height: scrollView.bounds.height
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for (index, imageView) in scrollView.subviews.enumerated() {
            imageView.frame = CGRect(
                x: CGFloat(index) * view.bounds.width,
                y: 0,
                width: view.bounds.width,
                height: scrollView.bounds.height
            )
        }

        scrollView.contentSize = CGSize(
            width: view.bounds.width * CGFloat(imageNames.count),
            height: scrollView.bounds.height
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }
}
