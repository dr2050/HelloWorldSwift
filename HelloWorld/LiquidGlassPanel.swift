// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class LiquidGlassPanel: UIView {
    private let blurView = UIVisualEffectView()

    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        setupView(cornerRadius: cornerRadius)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(cornerRadius: 0)
    }

    private func setupView(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        // Create blur effect
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurView.effect = blurEffect
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.5  // Make it more transparent
        insertSubview(blurView, at: 0)
    }
}
