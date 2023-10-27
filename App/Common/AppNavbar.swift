//
//  AppNavbar.swift
//  MobileAppSourceCodeV1
//
//  Created by Kaushal Chaudhary on 27/10/23.
//

import Foundation
import UIKit

class AppNavBar: UIView {
    let action: UIAction
    
    required init(action: UIAction, bgColor: UIColor) {
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = bgColor
        
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            backButton.topAnchor.constraint(equalTo: topAnchor),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            backButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    
}
