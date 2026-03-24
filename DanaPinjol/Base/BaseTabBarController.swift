//
//  BaseTabBarController.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.backgroundColor = .white
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let homeVC = createViewController(
            viewController: HomeViewController(),
            title: "",
            imageName: "home_nor_image",
            selectedImageName: "home_sel_image"
        )
        
        let orderVC = createViewController(
            viewController: OrderViewController(),
            title: "",
            imageName: "order_nor_image",
            selectedImageName: "order_sel_image"
        )
        
        let mineVC = createViewController(
            viewController: MineViewController(),
            title: "",
            imageName: "mine_nor_image",
            selectedImageName: "mine_sel_image"
        )
        
        viewControllers = [homeVC, orderVC, mineVC]
    }
    
    private func createViewController(viewController: UIViewController, title: String, imageName: String, selectedImageName: String) -> BaseNavigationController {
        viewController.title = title
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        )
        
        let navigationController = BaseNavigationController(rootViewController: viewController)
        return navigationController
    }
    
}

extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard LoginManager.shared.isLoggedIn() else {
            toLoginPage()
            return false
        }
        return true
    }
    
    func toLoginPage() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
}
