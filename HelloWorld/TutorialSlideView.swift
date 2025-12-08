// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class TutorialSlideView: UIView {
    
    private let imageView = UIImageView()
    private let textContentView: TutorialTextContentView
    
    init(imageName: String, index: Int) {
        // Figure out the localization keys from the index
        let number = String(format: "%02d", index + 1)
        let titleKey = "tutorial-slide-title-\(number)"
        let textKey = "tutorial-slide-text-\(number)"
        
        self.textContentView = TutorialTextContentView(titleKey: titleKey, textKey: textKey)
        
        super.init(frame: .zero)
        
        // Image fills the entire view
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
        
        addSubview(textContentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make sure we have valid bounds
        guard bounds.width > 0, bounds.height > 0 else { return }
        
        // Size the text content view to fit
        let maxWidth: CGFloat = min(400, bounds.width - 40)
        let size = textContentView.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        textContentView.frame = CGRect(
            x: bounds.width - size.width - 40,
            y: bounds.height - size.height - 20,
            width: size.width,
            height: size.height
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Text Content View

private class TutorialTextContentView: UIView {
    
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let stackView = UIStackView()
    
    init(titleKey: String, textKey: String) {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        

        // Title label
        titleLabel.text = NSLocalizedString(titleKey, comment: "")
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        // Text label
        textLabel.text = NSLocalizedString(textKey, comment: "")
        textLabel.font = .preferredFont(forTextStyle: .body)
        textLabel.textColor = .secondaryLabel
        textLabel.numberOfLines = 0
        
        // Stack view for labels
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textLabel)
        
        addSubview(stackView)
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width - 32
        titleLabel.preferredMaxLayoutWidth = maxWidth
        textLabel.preferredMaxLayoutWidth = maxWidth
        
        let stackSize = stackView.systemLayoutSizeFitting(
            CGSize(width: maxWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(width: stackSize.width + 32, height: stackSize.height + 32)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
