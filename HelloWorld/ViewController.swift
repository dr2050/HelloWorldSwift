import UIKit

class ViewController: UIViewController {
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("yes I am viewDidload")
        setupImageView()
        setupLiquidGlassPanel()
    }

    func setupImageView() {
        let image = UIImage(named: "liquid-glass-example-dry.png")
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
    }

    func setupLiquidGlassPanel() {
        guard let image = imageView.image else {
            fatalError("ImageView must have an image")
        }

        let panel = LiquidGlassPanel(cornerRadius: 20)
        panel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panel)

        let yPercentage: CGFloat = 0.57
        let widthPercentage: CGFloat = 0.9
        let heightPercentage: CGFloat = 0.15

        // Calculate displayed image size and position in aspect fit mode
        let imageAspectRatio = image.size.width / image.size.height
        let viewAspectRatio = imageView.bounds.width / imageView.bounds.height

        let displayedImageWidth: CGFloat
        let displayedImageHeight: CGFloat
        let displayedImageX: CGFloat
        let displayedImageY: CGFloat

        if imageAspectRatio > viewAspectRatio {
            // Image is constrained by width
            displayedImageWidth = imageView.bounds.width
            displayedImageHeight = displayedImageWidth / imageAspectRatio
            displayedImageX = 0
            displayedImageY = (imageView.bounds.height - displayedImageHeight) / 2
        } else {
            // Image is constrained by height
            displayedImageHeight = imageView.bounds.height
            displayedImageWidth = displayedImageHeight * imageAspectRatio
            displayedImageX = (imageView.bounds.width - displayedImageWidth) / 2
            displayedImageY = 0
        }

        // Calculate panel position and size relative to displayed image
        let panelWidth = displayedImageWidth * widthPercentage
        let panelHeight = displayedImageHeight * heightPercentage
        let panelX = displayedImageX + (displayedImageWidth - panelWidth) / 2
        let panelY = displayedImageY + (displayedImageHeight * yPercentage)

        NSLayoutConstraint.activate([
            panel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: panelX),
            panel.topAnchor.constraint(equalTo: view.topAnchor, constant: panelY),
            panel.widthAnchor.constraint(equalToConstant: panelWidth),
            panel.heightAnchor.constraint(equalToConstant: panelHeight),
        ])
    }
}
