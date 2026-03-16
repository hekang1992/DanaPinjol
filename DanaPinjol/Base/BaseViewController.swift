//
//  BaseViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

}

extension BaseViewController {
    
    func toLoginPage() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
}
