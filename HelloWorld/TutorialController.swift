// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

final class TutorialController: UIPageViewController {

    private let imageNames: [String]
    private lazy var slideControllers: [TutorialSlideContentController] = imageNames.enumerated().map {
        TutorialSlideContentController(imageName: $0.element, index: $0.offset)
    }
    private var currentIndex: Int = 0

    init(slug: String) {
        self.imageNames = Self.discoverImages(for: slug)
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        dataSource = self
        delegate = self

        setInitialPageIfNeeded()
    }
}

// MARK: - Helpers

private extension TutorialController {

    func setInitialPageIfNeeded() {
        guard let first = slideControllers.first else { return }
        currentIndex = first.index
        setViewControllers([first], direction: .forward, animated: false)
    }

    static func discoverImages(for slug: String) -> [String] {
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
}

// MARK: - UIPageViewControllerDataSource

extension TutorialController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let slide = viewController as? TutorialSlideContentController else { return nil }
        let previousIndex = slide.index - 1
        guard previousIndex >= 0 else { return nil }
        return slideControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let slide = viewController as? TutorialSlideContentController else { return nil }
        let nextIndex = slide.index + 1
        guard nextIndex < slideControllers.count else { return nil }
        return slideControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        slideControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        currentIndex
    }
}

// MARK: - UIPageViewControllerDelegate

extension TutorialController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let visible = viewControllers?.first as? TutorialSlideContentController else { return }
        currentIndex = visible.index
    }
}

// MARK: - Slide Container

private final class TutorialSlideContentController: UIViewController {

    let index: Int
    private let imageName: String

    init(imageName: String, index: Int) {
        self.index = index
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = TutorialSlideView(imageName: imageName, index: index)
    }
}
