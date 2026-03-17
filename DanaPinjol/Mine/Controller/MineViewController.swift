//
//  MineViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import MJRefresh

class MineViewController: BaseViewController {
    
    lazy var mineView: MineView = {
        let mineView = MineView()
        return mineView
    }()
    
    private let viewModel = MineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mineView)
        mineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mineView.clickBtnBlock = { [weak self] type in
            ToastWindowManager.showMessage(type.rawValue)
        }
        
        mineView.tapBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            self.juduePageToVc(pageUrl)
        }
        
        bindViewModel()
        
        self.mineView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.mineInfo()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mineInfo()
    }
    
}

extension MineViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    let modelArray = model.cylind?.stinguence ?? []
                    self.mineView.updateToolsView(with: modelArray)
                }
                self.mineView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.mineView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    private func mineInfo() {
        let parameters = ["ponttion": LoginManager.shared.getPhone() ?? ""]
        viewModel.mineInfo(parameters: parameters)
    }
}
