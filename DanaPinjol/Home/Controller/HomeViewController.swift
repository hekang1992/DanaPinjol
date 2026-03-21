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

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
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
    }
    
}

extension HomeViewController {
    
    private func clickProductInfo(with productId: String) {
        guard LoginManager.shared.isLoggedIn() else {
            toLoginPage()
            return
        }
        let parameters = ["allate": productId]
        viewModel.homeClickInfo(parameters: parameters)
    }
}
