//
//  ProductViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import TYAlertController
import MJRefresh

class ProductViewController: BaseViewController {
    
    var productId: String = ""
    
    private let viewModel = ProductViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var productView: ProductView = {
        let productView = ProductView(frame: .zero)
        return productView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        view.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        self.productView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.productDetailInfo()
        })
        
        self.productView.tapBlock = { [weak self] stepModel, model, type in
            guard let self = self else { return }
            let nextStr = stepModel.medi ?? ""
            let jug = stepModel.jug ?? 0
            if type == .next {
                self.toNextVC(with: model)
            }else {
                if jug == 0 {
                    self.toNextVC(with: model)
                }else {
                    self.completeAuth(with: nextStr, cylindModel: model)
                }
            }
        }
        
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productDetailInfo()
    }
    
}

extension ProductViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.confilgTitle("Product Details".localized)
        
        headView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension ProductViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if let cylindModel = model.cylind {
                        self.configHeadUI(with: cylindModel)
                    }
                }
                self.productView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.productView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        
    }
    
    private func productDetailInfo() {
        let parameters = ["allate": productId, "fell": "1"]
        viewModel.detailInfo(parameters: parameters)
    }
    
}

extension ProductViewController {
    
    private func configHeadUI(with model: cylindModel) {
        self.productView.model = model
    }
    
    private func completeAuth(with type: String, cylindModel: cylindModel) {
        
        switch type {
        case "dur":
            let faceVc = FaceViewController()
            faceVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(faceVc, animated: true)
            
        case "project":
            break
            
        case "job":
            break
            
        case "diseasead":
            break
            
        case "dudom":
            break
            
        default:
            break
        }
        
    }
    
}
