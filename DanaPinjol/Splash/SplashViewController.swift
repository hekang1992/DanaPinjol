//
//  SplashViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import Alamofire
import Combine
import FBSDKCoreKit

let CHANGE_ROOT_VC = Notification.Name("CHANGE_ROOT_VC")

class SplashViewController: BaseViewController {
    
    private let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorNetWorkInfo()
        
        bindViewModel()
        
    }
    
}

extension SplashViewController {
    
    private func monitorNetWorkInfo() {
        
        NetworkMonitor.shared.startListening { [weak self] status in
            guard let self else { return }
            
            switch status {
                
            case .notReachable:
                NetworkUserDefaults.shared.saveNetwotkType(type: "Bad Network")
                
            case .reachable(.ethernetOrWiFi):
                splashInfo()
                NetworkUserDefaults.shared.saveNetwotkType(type: "WIFI")
                NetworkMonitor.shared.stopListening()
                
            case .reachable(.cellular):
                splashInfo()
                NetworkUserDefaults.shared.saveNetwotkType(type: "5G")
                NetworkMonitor.shared.stopListening()
                
            case .unknown:
                NetworkUserDefaults.shared.saveNetwotkType(type: "Unknown Network")
                
            }
        }
    }
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
            }
            .store(in: &cancellables)
        
    }
    
    private func splashInfo() {
        
        let parameters = ["coavailableious": NetworkProxyChecker.getProxyStatus(),
                          "usable": NetworkProxyChecker.getVPNStatus(),
                          "capr": Locale.preferredLanguages.first ?? ""]
        
        viewModel.splashInfo(parameters: parameters)
        
    }
    
}

extension SplashViewController {
    
    private func uploadMarket(model: discussshipModel) {
        
    }
    
}
