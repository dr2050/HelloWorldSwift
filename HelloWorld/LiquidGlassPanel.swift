// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit
import SwiftUI

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
        let swiftUIView = LiquidGlassSwiftUIView(cornerRadius: cornerRadius)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(hostingController.view)
    }
}

struct LiquidGlassSwiftUIView: View {
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.red.opacity(0.5))
    }
}
