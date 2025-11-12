import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yes I am viewDidload")
        setupImageView()
    }

    func setupImageView() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "liquid-glass-example-dry.png")
        view.addSubview(imageView)
    }
}
