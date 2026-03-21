//
//  HomeViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import CombineCocoa
import Combine
import SnapKit
import MJRefresh
import AppTrackingTransparency
import AdSupport
import CoreLocation

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    private let locationManager = LocationManager()
    
    lazy var homeView: HomeView = {
        let homeView = HomeView(frame: .zero)
        homeView.isHidden = true
        return homeView
    }()
    
    lazy var mainView: MainView = {
        let mainView = MainView(frame: .zero)
        mainView.isHidden = true
        return mainView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.homeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.homeInfo()
        })
        
        homeView.tapProductBlock = { [weak self] productId in
            guard let self = self else { return }
            self.clickProductInfo(with: productId)
        }
        
        homeView.tapTwoImageViewBlock = { [weak self] in
            guard let self = self else { return }
            let pageUrl = h5_url + "/ably"
            self.juduePageToVc(pageUrl)
        }
        
        homeView.tapFourImageViewBlock = { [weak self] in
            guard let self = self else { return }
            let dedcVc = DescViewController()
            self.navigationController?.pushViewController(dedcVc, animated: true)
        }
        
        mainView.tapProductBlock = { [weak self] productId in
            guard let self = self else { return }
            self.clickProductInfo(with: productId)
        }
        
        self.mainView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.homeInfo()
        })
        
        bindViewModel()
        
        if LanguageManager.shared.getCurrentLanguage() == .indonesian {
            if LoginManager.shared.isLoggedIn() {
                let status = CLLocationManager().authorizationStatus
                if status == .denied || status == .restricted {
                    self.showPermissionAlert()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await requestTrackingPermission()
        }
    }
    
}

extension HomeViewController {
    
    private func showPermissionAlert() {
        let lastShownDate = UserDefaults.standard.object(forKey: "lastPermissionAlertDate") as? Date
        let isTodayShown = lastShownDate.map { Calendar.current.isDateInToday($0) } ?? false
        
        if isTodayShown {
            return
        }
        
        let alert = UIAlertController(
            title: "定位",
            message: "请在iPhone的\"设置-隐私-定位\"中允许应用访问定位",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "去设置", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
        UserDefaults.standard.set(Date(), forKey: "lastPermissionAlertDate")
    }
    
}

extension HomeViewController {
    
    private func requestTrackingPermission() async {
        let _ = await ATTrackingManager.requestTrackingAuthorization()
    }
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if viewModel.action == .home_info {
                        var listArray = model.cylind?.actuallyify ?? []
                        
                        if let targetItem = listArray.first(where: { $0.pathyish == "ficiy" }) {
                            if let oesophaglessArray = targetItem.oesophagless {
                                self.homeView.isHidden = false
                                self.mainView.isHidden = true
                                self.homeView.cardModel = oesophaglessArray.first
                            }
                        } else {
                            
                            if let index = listArray.firstIndex(where: { $0.pathyish == "audiness" }) {
                                listArray.remove(at: index)
                            }
                            
                            if let index = listArray.firstIndex(where: { $0.pathyish == "remainage" }) {
                                listArray.remove(at: index)
                            }
                            
                            self.mainView.modelArray = listArray
                            self.homeView.isHidden = true
                            self.mainView.isHidden = false
                        }
                        
                    }else {
                        let pageUrl = model.cylind?.thero ?? ""
                        self.juduePageToVc(pageUrl)
                    }
                }
                self.homeView.scrollView.mj_header?.endRefreshing()
                self.mainView.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.homeView.scrollView.mj_header?.endRefreshing()
                self.mainView.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - home api
    private func homeInfo() {
        viewModel.homeInfo()
        if LoginManager.shared.isLoggedIn() {
            locationInfo()
            macInfo()
        }
    }
    
}

extension HomeViewController {
    
    private func clickProductInfo(with productId: String) {
        guard LoginManager.shared.isLoggedIn() else {
            toLoginPage()
            return
        }
        
        self.locationInfo()
        self.macInfo()
        
        let parameters = ["allate": productId]
        viewModel.homeClickInfo(parameters: parameters)
    }
    
    private func uploadLocationInfo(with parameters: [String: String]) {
        viewModel.uploadLocationInfo(parameters: parameters)
    }
}

extension HomeViewController {
    
    private func locationInfo() {
        locationManager.requestLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let locationInfo):
                let parameters = locationInfo.toDictionary()
                self.uploadLocationInfo(with: parameters)
                
            case .failure(let error):
                print("location error: \(error.localizedDescription)")
            }
        }
    }
    
    private func macInfo() {
        DeviceInfoCollector.shared.collectAllInfo { [weak self] result in
            guard let self else { return }
            let base64Str = encodeToBase64(result) ?? ""
            let parameters = ["cylind": base64Str]
            viewModel.uploadMacInfo(parameters: parameters)
        }
    }
    
    func encodeToBase64(_ result: [String: Any]) -> String? {
        guard JSONSerialization.isValidJSONObject(result) else {
            return nil
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: [])
            let base64String = jsonData.base64EncodedString()
            return base64String
        } catch {
            return nil
        }
    }
    
}
