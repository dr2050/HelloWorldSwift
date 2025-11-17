import UIKit

class ViewController: UIViewController {
    let imageView = UIImageView()
    private var panelWidthConstraint: NSLayoutConstraint?
    private var panelHeightConstraint: NSLayoutConstraint?
    private var shrinkTimer: Timer?
    private var glassPanel: LiquidGlassBackgroundView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("yes I am viewDidload")
        setupImageView()
        setupLiquidGlassPanel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shrinkTimer?.invalidate()
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

        let panel = LiquidGlassBackgroundView(cornerRadius: 40)
        panel.glassTintColor = UIColor.orange.withAlphaComponent(0.0001)
        panel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panel)
        glassPanel = panel

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
        ])

        let widthConstraint = panel.widthAnchor.constraint(equalToConstant: panelWidth)
        let heightConstraint = panel.heightAnchor.constraint(equalToConstant: panelHeight)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])

        panelWidthConstraint = widthConstraint
        panelHeightConstraint = heightConstraint

        startPanelShrinkTimer()
    }

    private func startPanelShrinkTimer() {
        shrinkTimer?.invalidate()
        shrinkTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.shrinkPanel(by: 0.05)
            }
        }
    }

    private func shrinkPanel(by percentage: CGFloat) {
        guard let widthConstraint = panelWidthConstraint,
              let heightConstraint = panelHeightConstraint,
              percentage > 0,
              percentage < 1 else {
            return
        }

        let reductionFactor = 1.0 - percentage
        let newWidth = max(widthConstraint.constant * reductionFactor, 10)
        let newHeight = max(heightConstraint.constant * reductionFactor, 10)

        guard newWidth < widthConstraint.constant || newHeight < heightConstraint.constant else {
            return
        }

        widthConstraint.constant = newWidth
        heightConstraint.constant = newHeight

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        glassPanel?.glassTintColor = randomGlassColor()
    }
    
    private func randomGlassColor() -> UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.4...0.9)
        let brightness = CGFloat.random(in: 0.6...1)
        let alpha = CGFloat.random(in: 0.4...1)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
