// Title: Helloworld UIToolbar No-Bubble Attempt
// Version: 1

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        let bar = UIToolbar(frame: CGRect(x: 30, y: 60, width: view.bounds.width, height: 66))
        bar.backgroundColor = .orange
        bar.autoresizingMask = [.flexibleWidth]
        bar.isTranslucent = false

        let a = UIToolbarAppearance()
        a.configureWithOpaqueBackground()
        a.backgroundColor = .black

        bar.standardAppearance = a
        bar.compactAppearance = a
        bar.scrollEdgeAppearance = a

        let one = UIBarButtonItem(title: "One", style: .plain, target: nil, action: nil)
        let two = UIBarButtonItem(title: "Two", style: .plain, target: nil, action: nil)

        bar.items = [one, two]

        view.addSubview(bar)
    }
}
