//
//  Initial.swift
//  MobileAppSourceCodeV1
//
//  Created by Kaushal Chaudhary on 23/10/23.
//

import Foundation
import UIKit

class Initial: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        let homeVC = createTabs(BaseViewController(), title: Local.home, unselectedImage: Asset.home_unselected, selectedImage: Asset.home_selected)
       
        let allProductsVC = createTabs(All(), title: Local.all, unselectedImage: Asset.all_unselected, selectedImage: Asset.all_selected)

        let cartVC = createTabs(Cart(), title: Local.cart, unselectedImage: Asset.cart_unselected, selectedImage: Asset.cart_selected)

        let accountVC = createTabs(Account(), title: Local.account, unselectedImage: Asset.account_unselected, selectedImage: Asset.account_selected)
        
        let controllers = [homeVC, allProductsVC, cartVC, accountVC]
        self.viewControllers = controllers
        
        func createTabs(_ viewController: UIViewController, title: String, unselectedImage: UIImage, selectedImage: UIImage) -> UIViewController {
            
            func getModifiedImage(for image: UIImage) -> UIImage {
                return image.resize(targetSize: .init(width: 24, height: 24)).withRenderingMode(.alwaysOriginal).withTintColor(.P1)
            }
            
            viewController.tabBarItem = UITabBarItem(
                title: title,
                image: getModifiedImage(for: unselectedImage),
                selectedImage: getModifiedImage(for: selectedImage)
            )
            
            viewController.tabBarItem.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.P1,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
                ],
                for: .normal
            )
            
            return viewController
        }
    }
}
