//
//  Initial.swift
//  MobileAppSourceCodeV1
//
//  Created by Himanshu Singh on 22/10/23.
//

import UIKit

class Initial: UITabBarController,UITabBarControllerDelegate {
    
    class TabBarView: UIView {
        struct TabItem {
            weak var viewController: UIViewController!
            let selectedText: String
            let unselectedText: String
            let selectedImage: UIImage
            let unselectedImage: UIImage
            init(viewController: UIViewController, selectedText: String, unselectedText: String? = nil, selectedImage: UIImage, unselectedImage: UIImage) {
                let nav = UINavigationController(rootViewController: viewController)
                nav.isNavigationBarHidden = true
                self.viewController = nav
                self.selectedText = selectedText
                self.unselectedText = unselectedText ?? selectedText
                self.selectedImage = selectedImage
                self.unselectedImage = unselectedImage
            }
        }
        let selectedBackgroundColor: UIColor
        let unselectedBackgroundColor: UIColor
        let indicatorColor: UIColor
        let items: [TabItem]
        weak var tabController: UITabBarController?
        
        
        class TabItemView: UIView {
            deinit {
                print("deiinit TabItemView")
            }
            var didSelected:( (Int) -> Void )?
            var selected:( (Bool) -> Void )?
            var index: Int
            init(item: TabItem,index: Int) {
                self.index = index
                super.init(frame: .zero)
                self.translatesAutoresizingMaskIntoConstraints = false
                let image = UIImageView()
                image.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(image)
                NSLayoutConstraint.activate([
                    image.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
                    image.heightAnchor.constraint(equalToConstant: 22),
                    image.widthAnchor.constraint(equalToConstant: 22),
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
                
                
                let title = UILabel()
                title.textAlignment = .center
                title.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(title)
                title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
                NSLayoutConstraint.activate([
                    title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 1),
                    title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
                    title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
                ])
                
                let indicator = UIView()
                indicator.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(indicator)
                NSLayoutConstraint.activate([
                    indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8),
                    indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -8),
                    indicator.bottomAnchor.constraint(equalTo: self.topAnchor,constant: 4),
                    indicator.heightAnchor.constraint(equalToConstant: 4)
                ])
                indicator.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                indicator.layer.cornerRadius = 4
                
                selected = { [weak self] isSelected in
                    guard let self = self else { return }
                    if isSelected {
                        image.image = item.selectedImage
                        title.text = item.selectedText
                        title.font = .systemFont(ofSize: 12, weight: .semibold)
                        title.textColor = .P1
                        self.backgroundColor = .clear
                        indicator.backgroundColor = .P1
                    } else {
                        image.image = item.unselectedImage
                        title.text = item.unselectedText
                        title.font = .systemFont(ofSize: 11, weight: .medium)
                        title.textColor = .P1
                        self.backgroundColor = .clear
                        indicator.backgroundColor = .clear
                    }
                }
                let button = UIButton(type: .system)
                
                button.addAction(.init(handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.didSelected?(self.index)
                }), for: .touchUpInside)
                
                self.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    button.topAnchor.constraint(equalTo: self.topAnchor),
                    button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                ])
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        var selectedIndex = 0
        
        init(selectedBackgroundColor: UIColor, unselectedBackgroundColor: UIColor, indicatorColor: UIColor, items: [TabItem],inTabController: UITabBarController) {
            self.selectedBackgroundColor = selectedBackgroundColor
            self.unselectedBackgroundColor = unselectedBackgroundColor
            self.indicatorColor = indicatorColor
            self.items = items
            self.tabController = inTabController
            super.init(frame: .zero)
            self.translatesAutoresizingMaskIntoConstraints = false
            setUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUI() {
            self.backgroundColor = .white
            
            
            let line: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                view.backgroundColor = .B1
                return view
            }()
            self.addSubview(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                line.topAnchor.constraint(equalTo: self.topAnchor)
            ])
            let stack = UIStackView()
            
            func generateTabItem(for item: TabItem,index: Int) -> UIView {
                let view = TabItemView(item: item, index: index)
                view.didSelected = { [weak self] index in
                    stack.subviews.forEach { view in
                        (view as? TabItemView)?.selected?(false)
                    }
                    view.selected?(true)
                    self?.tabController?.selectedIndex = index
                }
                view.selected?(false)
                return view
            }
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .horizontal
            
            var count = 0
            self.items.forEach({ item in
                stack.addArrangedSubview(generateTabItem(for: item, index: count))
                count = count + 1
            })
            
            let vcs = self.items.reduce([UIViewController]()) { partialResult, item in
                var new = partialResult
                new.append(item.viewController)
                return new
            }
            
            self.tabController?.setViewControllers(vcs, animated: true)
            self.addSubview(stack)
            stack.spacing = 0
            stack.distribution = .fillEqually
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                stack.topAnchor.constraint(equalTo: self.topAnchor),
            ])
            (stack.subviews.first as? TabItemView)?.selected?(true)
            
           
            
        }
    }
    
    
    class CustomTabBar : UITabBar {
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            super.sizeThatFits(size)
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 56
            return sizeThatFits
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.subviews.first?.alpha = 0
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        
        let tabbar = TabBarView(selectedBackgroundColor: .P1.withAlphaComponent(0.4), unselectedBackgroundColor: .white, indicatorColor: .P1, items: [
            .init(viewController: Home(), selectedText: Local.home, selectedImage: Asset.home_selected.withTintColor(.P1), unselectedImage: Asset.home_selected.withTintColor(.P1)),
            
                .init(viewController: All(), selectedText: Local.all, selectedImage: Asset.all_selected.withTintColor(.P1), unselectedImage: Asset.all_selected.withTintColor(.P1)),
            
                .init(viewController: Cart(), selectedText: Local.cart, selectedImage: Asset.cart_selected.withTintColor(.P1), unselectedImage: Asset.cart_unselected.withTintColor(.P1)),
            
                .init(viewController: Account(), selectedText: Local.account, selectedImage: Asset.account_selected.withTintColor(.P1), unselectedImage: Asset.account_unselected.withTintColor(.P1)),
        ], inTabController: self)
        
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(tabbar)
        tabbar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        NSLayoutConstraint.activate([
            tabbar.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor),
            tabbar.bottomAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.window?.backgroundColor = .white
        let frame: CGRect = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 34)
        self.view.frame = frame
    }
}

