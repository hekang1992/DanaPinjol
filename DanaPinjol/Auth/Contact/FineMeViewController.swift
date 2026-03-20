//
//  FineMeViewController.swift
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

class FineMeViewController: BaseViewController {
    
    private let viewModel = FineMeViewModel()
    
    private let productViewModel = ProductViewModel()
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ContractViewCell.self, forCellReuseIdentifier: "ContractViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    var modelArray: [actuallyifyModel] = []
    
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        nextBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let listArray = viewModel.model?.cylind?.lud ?? []
                var parameters = ["allate": cylindModel?.seish?.side ?? ""]
                for model in listArray {
                    let key = model.lentfier ?? ""
                    let value = model.pathyish ?? ""
                    parameters[key] = value
                }
                viewModel.saveContactInfo(parameters: parameters)
            }
            .store(in: &cancellables)
        
    }
    
}

extension FineMeViewController {
    
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
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfo()
    }
    
}

extension FineMeViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    self.modelArray = model.cylind?.college?.actuallyify ?? []
                }else {
                    ToastWindowManager.showMessage(model.plurimon ?? "")
                }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$saveModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
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
        viewModel.contactInfo(parameters: parameters)
    }
    
    private func productDetailInfo() {
        let parameters = ["allate": cylindModel?.seish?.side ?? "", "fell": "1"]
        productViewModel.detailInfo(parameters: parameters)
    }
    
}

extension FineMeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractViewCell", for: indexPath) as! ContractViewCell
        let model = self.modelArray[indexPath.row]
        cell.model = model
        cell.oneBlock = { [weak self] in
            guard let self = self else { return }
            self.showTapAlert(with: "", model: model, cell: cell)
        }
        cell.twoBlock = { [weak self] in
            guard let self = self else { return }
        }
        return cell
    }
    
}

extension FineMeViewController {
    
    private func showTapAlert(with name: String, model: actuallyifyModel, cell: ContractViewCell) {
        let popView = PopSelectAuthListView(frame: self.view.bounds)
        
        let listArray = model.clysally ?? []
        
        popView.modelArray = listArray
        
        popView.nameLabel.text = model.manuality ?? ""
        
        if let selectedValue = cell.oneView.phoneTextFiled.text,
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
            model.ovilawose = listModel.pathyish ?? ""
            cell.oneView.phoneTextFiled.text = listModel.trueacle ?? ""
        }
    }
    
}
