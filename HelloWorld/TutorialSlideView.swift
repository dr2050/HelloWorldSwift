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

        // Set up Auto Layout for text content view
        textContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            textContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            textContentView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            textContentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40)
        ])
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
        
        backgroundColor = .black.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        

        // Title label
        titleLabel.text = local(titleKey)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        // Text label
        textLabel.text = local(textKey)
        textLabel.font = .preferredFont(forTextStyle: .body)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        
        // Stack view for labels
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textLabel)

        addSubview(stackView)

        // Set up Auto Layout for stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
