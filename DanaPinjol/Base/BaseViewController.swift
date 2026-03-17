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
    
    lazy var headView: AppHeadView = {
        let headView = AppHeadView(frame: .zero)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension BaseViewController {
    
    func toLoginPage() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
    func juduePageToVc(_ pageUrl: String) {
        if pageUrl.contains(MorningyRouter.shared.scheme_url) {
            if let navigationController = self.navigationController, let url = URL(string: pageUrl) {
                MorningyRouter.shared.handle(url: url, navigationController: navigationController)
            }
        }else {
            let webVc = H5WebViewController()
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }
    
}
