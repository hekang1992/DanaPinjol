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

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    lazy var homeView: HomeView = {
        let homeView = HomeView(frame: .zero)
        return homeView
    }()
    
    lazy var mainView: MainView = {
        let mainView = MainView(frame: .zero)
        return mainView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.homeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.homeInfo()
        })
        
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeInfo()
    }
    
}

extension HomeViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    
                }
                self.homeView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.homeView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - home api
    private func homeInfo() {
        viewModel.homeInfo()
    }
    
}
