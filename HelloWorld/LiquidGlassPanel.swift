// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import SwiftUI
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
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        let swiftUIView = LiquidGlassSwiftUIView(cornerRadius: cornerRadius)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(hostingController.view)
    }
}

private struct LiquidGlassSwiftUIView: View {
    let cornerRadius: CGFloat

    var body: some View {
        let r = RoundedRectangle(cornerRadius: cornerRadius)
        Rectangle().fill(.clear)
            .frame(width: .infinity, height: 200)
            .glassEffect(.clear)
            .mask(r)
    }
}
