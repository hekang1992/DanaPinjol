//
//  OrderListViewController.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import MJRefresh

class OrderListViewController: BaseViewController {
    
    private let viewModel = OrderViewModel()
    
    var type: String = "4"
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.confilgTitle(name.localized)
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
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
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "OrderTableViewCell")
        tableView.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView(frame: .zero)
        emptyView.isHidden = true
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.orderListInfo()
        })
        
        emptyView.emptyBtnBlock = {
            NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
        }
        
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderListInfo()
    }
    
}

extension OrderListViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}

extension OrderListViewController {
    
    private func bindViewModel() {
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    let listArray = model.cylind?.actuallyify ?? []
                    if listArray.count == 0 || listArray.isEmpty {
                        self.tableView.isHidden = true
                        self.emptyView.isHidden = false
                    }else {
                        self.tableView.isHidden = false
                        self.emptyView.isHidden = true
                    }
                }
                self.tableView.reloadData()
                self.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
    }
    
    private func orderListInfo() {
        let parameters = ["quartuous": type, "marcomputerian": "1", "shakefaction": "60"]
        viewModel.orderListInfo(parameters: parameters)
    }
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model?.cylind?.actuallyify?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        let model = viewModel.model?.cylind?.actuallyify?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.model?.cylind?.actuallyify?[indexPath.row]
        let pageUrl = model?.emulable ?? ""
        self.juduePageToVc(pageUrl)
    }
    
}
