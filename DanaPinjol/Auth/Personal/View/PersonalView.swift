//
//  PersonalView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/19.
//

import UIKit
import SnapKit

class PersonalView: BaseView {
    
    var tapTimeBlock: ((String, ludModel, AppTapViewCell) -> Void)?
    
    var modelArray: [ludModel]? {
        didSet {
            guard let _ = modelArray else { return }
            tableView.reloadData()
        }
    }
    
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
        tableView.register(AppInputViewCell.self, forCellReuseIdentifier: "AppInputViewCell")
        tableView.register(AppTapViewCell.self, forCellReuseIdentifier: "AppTapViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PersonalView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listModel = self.modelArray?[indexPath.row]
        let blackence = listModel?.blackence ?? ""
        if blackence == "significantule" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInputViewCell", for: indexPath) as! AppInputViewCell
            cell.model = listModel
            cell.onTextChange = { [weak self] text in
                guard let self else { return }
                listModel?.irasc = text
                listModel?.pathyish = text
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppTapViewCell", for: indexPath) as! AppTapViewCell
            cell.model = listModel
            cell.tapTimeBlock = { [weak self] text in
                guard let self, let listModel else { return }
                self.tapTimeBlock?(text, listModel, cell)
            }
            return cell
        }
    }
    
}
