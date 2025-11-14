// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import SwiftUI
import UIKit

@objcMembers
public final class LiquidGlassBackgroundView: UIView {
    private let cornerRadius: CGFloat
    private let tintModel: GlassTintModel
    private let hostingController: UIHostingController<LiquidGlassSwiftUIView>
    
    public var glassTintColor: UIColor {
        didSet { tintModel.tintColor = Color(glassTintColor) }
    }
    
    override public var backgroundColor: UIColor? {
        set {
            print("what")
        }
        get { return nil }
    }
    
    // MARK: - Init
    
    public init(cornerRadius: CGFloat, glassTintColor: UIColor = .clear) {
        self.cornerRadius = cornerRadius
        self.glassTintColor = glassTintColor
        tintModel = GlassTintModel()
        tintModel.tintColor = Color(glassTintColor)
        hostingController = UIHostingController(
            rootView: LiquidGlassSwiftUIView(
                cornerRadius: cornerRadius,
                tintModel: tintModel
            )
        )
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("no")
    }
}

// MARK: - Private

extension LiquidGlassBackgroundView {
    private func setupView() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(hostingController.view)
    }
}

private struct LiquidGlassSwiftUIView: View {
    let cornerRadius: CGFloat
    @ObservedObject var tintModel: GlassTintModel
    
    var body: some View {
        if #available(iOS 26, *) {
            let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            
            ZStack {
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: .infinity)
                    .glassEffect(.clear.tint(tintModel.tintColor), in: shape)
            }
        } else {
            EmptyView()
        }
    }
}

private final class GlassTintModel: ObservableObject {
    @Published var tintColor: Color = .clear
}
