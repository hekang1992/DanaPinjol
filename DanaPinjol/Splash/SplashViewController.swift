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
import SnapKit

let CHANGE_ROOT_VC = Notification.Name("CHANGE_ROOT_VC")

class SplashViewController: BaseViewController {
    
    private let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "splash_image")
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bindViewModel()
        
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 250_000_000)
            self?.monitorNetWorkInfo()
        }
        
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
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if let marketModel = model.cylind?.discussship {
                        self.uploadMarket(model: marketModel)
                    }
                    
                    let serverLanguageCode = model.cylind?.probablyar ?? ""
                    
                    LanguageManager.shared.setLanguageFromServerCode(serverLanguageCode)
                    
                    NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
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
        
        Settings.shared.displayName = model.naturalably ?? ""
        Settings.shared.appURLSchemeSuffix = model.toughture ?? ""
        Settings.shared.appID = model.myee ?? ""
        Settings.shared.clientToken = model.trialition ?? ""
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
        
    }
    
}
