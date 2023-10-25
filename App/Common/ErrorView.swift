//
//  NoInternetView.swift
//  MobileAppSourceCodeV1
//
//  Created by Kaushal Chaudhary on 25/10/23.
//

import Foundation
import UIKit

class ErrorView: UIView {
    let buttonTitle, title: String?
    let buttonAction: UIAction?
    let image: UIImage?
    
    init(title: String, image: UIImage, buttonTitle: String, buttonAction: UIAction) {
        self.title = title
        self.image = image
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        self.buttonTitle = nil
        self.title = nil
        self.image = nil
        self.buttonAction = nil
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(tryAgainButton)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            
            tryAgainButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        self.tag = 101
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = self.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        if let title = title {
            label.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.P1])
        }
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
            button.setAttributedTitle( NSAttributedString(string: buttonTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.P1]), for: .normal)
            button.addAction(buttonAction, for: .touchUpInside)
        }
        return button
    }()
}
