import UIKit

class ViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let root = UIViewController()
        root.view.backgroundColor = .systemBackground
        root.title = "Main"

        let button = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(showAnother)
        )

        root.navigationItem.rightBarButtonItem = button
        viewControllers = [root]
    }

    @objc private func showAnother() {
        let vc = TutorialController(slug: "ipad")
        pushViewController(vc, animated: true)
    }
}
