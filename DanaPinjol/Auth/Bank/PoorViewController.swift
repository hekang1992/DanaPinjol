//
//  PoorViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/19.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import TYAlertController
import MJRefresh

class PoorViewController: BaseViewController {
    
    private let viewModel = PoorViewModel()
    
    private let productViewModel = ProductViewModel()
    
    private let locationManager = LocationManager()
    
    private var stime: String = ""
    
    var cylindModel: cylindModel? {
        didSet {
            guard let cylindModel = cylindModel else { return }
            headView.confilgTitle(cylindModel.priviical?.hetercarryar ?? "")
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        nextBtn.setTitle("Next".localized, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextBtn.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "sct_head_image".localized)
        return headImageView
    }()
    
    lazy var listView: PersonalView = {
        let listView = PersonalView()
        return listView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.size.equalTo(CGSize(width: 315.pix(), height: 48.pix()))
        }
        
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 335.pix(), height: 64.pix()))
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        nextBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let listArray = viewModel.model?.cylind?.lud ?? []
                var parameters = ["allate": cylindModel?.seish?.side ?? ""]
                for model in listArray {
                    let key = model.lentfier ?? ""
                    if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                        let value = model.pathyish ?? ""
                        parameters[key] = value
                    }else {
                        let value = model.irasc ?? ""
                        parameters[key] = value
                    }
                }
                viewModel.saveBankInfo(parameters: parameters)
            }
            .store(in: &cancellables)
        
        locationManager.requestLocation { _ in }
        stime = String(Date().timeIntervalSince1970)
    }
    
}

extension PoorViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.onBackButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.toProductStepPage()
        }
        
        listView.tapTimeBlock = { [weak self] text, model, cell in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.showTapAlert(with: text, model: model, cell: cell)
        }
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfo()
    }
    
}

extension PoorViewController {
    
    private func showTapAlert(with name: String, model: ludModel, cell: AppTapViewCell) {
        let popView = PopSelectAuthListView(frame: self.view.bounds)
        
        let listArray = model.graphodom ?? []
        
        popView.modelArray = listArray
        
        popView.nameLabel.text = model.hetercarryar ?? ""
        
        if let selectedValue = cell.phoneTextFiled.text,
           let selectedIndex = listArray.firstIndex(where: { $0.trueacle == selectedValue }) {
            popView.selectedIndex = selectedIndex
        }
        
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.confirmBlock = { [weak self] listModel in
            guard let _ = self else { return }
            self?.dismiss(animated: true)
            model.irasc = listModel.trueacle ?? ""
            model.pathyish = listModel.pathyish ?? ""
            cell.phoneTextFiled.text = listModel.trueacle ?? ""
        }
    }
    
}

extension PoorViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    self.listView.modelArray = model.cylind?.lud ?? []
                }else {
                    ToastWindowManager.showMessage(model.plurimon ?? "")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$saveModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    self.dpAppInfo(with: "7", foss: stime)
                    self.productDetailInfo()
                }else {
                    ToastWindowManager.showMessage(model.plurimon ?? "")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            }
            .store(in: &cancellables)
        
        productViewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if let cylindModel = model.cylind {
                        self.toNextVC(with: cylindModel)
                    }
                }
                
            }
            .store(in: &cancellables)
        
    }
    
    private func listInfo() {
        let productId = cylindModel?.seish?.side ?? ""
        let parameters = ["allate": productId]
        viewModel.bankInfo(parameters: parameters)
    }
    
    private func productDetailInfo() {
        let parameters = ["allate": cylindModel?.seish?.side ?? "", "fell": "1"]
        productViewModel.detailInfo(parameters: parameters)
    }
    
}

extension PoorViewController {
    
    private func dpAppInfo(with scorear: String, foss: String) {
        let parameters = ["noweer": cylindModel?.seish?.side ?? "",
                          "scorear": scorear,
                          "cultural": cylindModel?.seish?.cultural ?? "",
                          "foss": foss,
                          "micrial": String(Int(Date().timeIntervalSince1970))]
        productViewModel.uploadPointInfo(parameters: parameters)
    }
    
}
