//
//  MainView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit

class MainView: BaseView {
    
    var tapProductBlock: ((String) -> Void)?

    var modelArray: [actuallyifyModel]? {
        didSet {
            guard let _ = modelArray else { return }
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeCardViewCell.self, forCellReuseIdentifier: "HomeCardViewCell")
        tableView.register(HomeProductListViewCell.self, forCellReuseIdentifier: "HomeProductListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 28.pix()
        }else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headView = UIView()
            let label = UILabel()
            label.text = "Produk pinjaman"
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.textColor = UIColor.init(hexString: "#082217")
            headView.addSubview(label)
            label.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-15.pix())
                make.left.equalToSuperview().offset(20.pix())
                make.height.equalTo(13.pix())
            }
            return headView
        }else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?[section].oesophagless?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.modelArray?[indexPath.section]
        let listModel = model?.oesophagless?[indexPath.row]
        
        let type = model?.pathyish ?? ""
        
        if type == "amphPMivity" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCardViewCell", for: indexPath) as! HomeCardViewCell
            cell.model = listModel
            cell.tapProductBlock = { [weak self] productId in
                guard let self = self else { return }
                self.tapProductBlock?(productId)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductListViewCell", for: indexPath) as! HomeProductListViewCell
            cell.model = listModel
            cell.tapProductBlock = { [weak self] productId in
                guard let self = self else { return }
                self.tapProductBlock?(productId)
            }
            return cell
        }
        
    }
    
}
