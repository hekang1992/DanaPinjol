//
//  MorningyRouter.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit

class MorningyRouter {
    
    static let shared = MorningyRouter()
    
    let scheme_url = "morningy://novice.loquel.old"
    
    private init() {}
    
    func handle(url: URL, navigationController: UINavigationController?) {
        guard url.scheme == "morningy" else { return }
        
        let path = url.path
        let params = parseQuery(url: url)
        
        switch path {
            
        case "/stencloseal":
            pushHome(navigationController)
            
        case "/plethard":
            pushSettings(navigationController)
            
        case "/ovilawose":
            pushLogin(navigationController)
            
        case "/heavyfication":
            pushOrderList(navigationController, params: params)
            
        case "/gon":
            pushProductDetail(navigationController, params: params)
            
        case "/naturalably":
            pushCustomerService(navigationController)
            
        default:
            print("error=path===: \(path)")
        }
    }
}

extension MorningyRouter {
    
    private func parseQuery(url: URL) -> [String: String] {
        var dict: [String: String] = [:]
        
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .forEach { item in
                dict[item.name] = item.value
            }
        
        return dict
    }
}

extension MorningyRouter {
    
    private func pushHome(_ nav: UINavigationController?) {
        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
    }
    
    private func pushSettings(_ nav: UINavigationController?) {
        let vc = SettingsViewController()
        nav?.pushViewController(vc, animated: true)
    }
    
    private func pushLogin(_ nav: UINavigationController?) {
        LoginManager.shared.clearLoginInfo()
        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
    }
    
    private func pushOrderList(_ nav: UINavigationController?, params: [String: String]) {
        
    }
    
    private func pushProductDetail(_ nav: UINavigationController?, params: [String: String]) {
        let vc = ProductViewController()
        vc.productId = params["allate"] ?? ""
        nav?.pushViewController(vc, animated: true)
    }
    
    private func pushCustomerService(_ nav: UINavigationController?) {
        
    }
}
