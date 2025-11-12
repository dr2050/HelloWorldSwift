// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class LiquidGlassPanel: UIView {

    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        setupView(cornerRadius: cornerRadius)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(cornerRadius: 0)
    }

    private func setupView(cornerRadius: CGFloat) {
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        layer.cornerRadius = cornerRadius
    }
}
