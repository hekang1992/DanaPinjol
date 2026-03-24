//
//  OrderViewController.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import MJRefresh

class OrderViewController: BaseViewController {
    
    private var buttons: [UIButton] = []
    
    private let viewModel = OrderViewModel()
    
    var type: String = "4"
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        return bgImageView
    }()
    
    lazy var desImageView: UIImageView = {
        let desImageView = UIImageView()
        desImageView.image = UIImage(named: "occ_ad_image")
        return desImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.isSelected = true
        oneBtn.setBackgroundImage(UIImage(named: "en_all_nor_image".localized), for: .normal)
        oneBtn.setBackgroundImage(UIImage(named: "en_all_sel_image".localized), for: .selected)
        oneBtn.adjustsImageWhenHighlighted = false
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_nor_image".localized), for: .normal)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_sel_image".localized), for: .selected)
        twoBtn.adjustsImageWhenHighlighted = false
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_nor_image".localized), for: .normal)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_sel_image".localized), for: .selected)
        threeBtn.adjustsImageWhenHighlighted = false
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setBackgroundImage(UIImage(named: "en_coc_nor_image".localized), for: .normal)
        fourBtn.setBackgroundImage(UIImage(named: "en_coc_sel_image".localized), for: .selected)
        fourBtn.adjustsImageWhenHighlighted = false
        return fourBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
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
        
        buttons = [oneBtn, twoBtn, threeBtn, fourBtn]
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(desImageView)
        desImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(142.pix())
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(desImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44.pix())
        }
        
        scrollView.addSubview(oneBtn)
        scrollView.addSubview(twoBtn)
        scrollView.addSubview(threeBtn)
        scrollView.addSubview(fourBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 94.pix(), height: 44.pix()))
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneBtn.snp.right)
            make.size.equalTo(CGSize(width: 94.pix(), height: 44.pix()))
        }
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoBtn.snp.right)
            make.size.equalTo(CGSize(width: 94.pix(), height: 44.pix()))
        }
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(threeBtn.snp.right)
            make.size.equalTo(CGSize(width: 95.pix(), height: 44.pix()))
            make.right.equalToSuperview().offset(-5.pix())
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.orderListInfo()
        })
        
        emptyView.emptyBtnBlock = { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 0
        }
        
        bindClickTap()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderListInfo()
    }
}

extension OrderViewController {
    
    private func bindClickTap() {
        
        oneBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectButton(self.oneBtn)
            }
            .store(in: &cancellables)
        
        twoBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectButton(self.twoBtn)
            }
            .store(in: &cancellables)
        
        threeBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectButton(self.threeBtn)
            }
            .store(in: &cancellables)
        
        fourBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectButton(self.fourBtn)
            }
            .store(in: &cancellables)
    }
    
    private func selectButton(_ selectedButton: UIButton) {
        
        buttons.forEach { button in
            button.isSelected = false
        }
        
        selectedButton.isSelected = true
        
        handleButtonSelection(selectedButton)
    }
    
    private func handleButtonSelection(_ button: UIButton) {
        switch button {
        case oneBtn:
            self.type = "4"
            self.orderListInfo()
            
        case twoBtn:
            self.type = "7"
            self.orderListInfo()
            
        case threeBtn:
            self.type = "6"
            self.orderListInfo()
            
        case fourBtn:
            self.type = "5"
            self.orderListInfo()
            
        default:
            break
        }
    }
}

extension OrderViewController {
    
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
                }else if lentfier == "-2" {
                    LoginManager.shared.clearLoginInfo()
                    self.toLoginPage()
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

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
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
