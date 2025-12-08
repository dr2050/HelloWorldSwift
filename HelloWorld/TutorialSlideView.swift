// (c) Confusion Studios LLC and affiliates. Confidential and proprietary.

import UIKit

class TutorialSlideView: UIView {
    
    private let imageView = UIImageView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    
    init(imageName: String, index: Int) {
        super.init(frame: .zero)
        
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Container for the text content with background
        containerView.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        // Figure out the localization keys from the index
        let number = String(format: "%02d", index + 1)
        let titleKey = "tutorial-slide-title-\(number)"
        let textKey = "tutorial-slide-text-\(number)"
        
        titleLabel.text = NSLocalizedString(titleKey, comment: "")
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        textLabel.text = NSLocalizedString(textKey, comment: "")
        textLabel.font = .preferredFont(forTextStyle: .body)
        textLabel.textColor = .secondaryLabel
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        
        addSubview(imageView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
