//
//  PopSelectAuthListView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import SnapKit

class PopSelectAuthListView: BaseView {
    
    // MARK: - Callback
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: ((graphodomModel) -> Void)?
    
    // MARK: - Data
    var modelArray: [graphodomModel] = []
    
    var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI
    private lazy var bgImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "pe_aco_bg_image"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Confirm".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setBackgroundImage(UIImage(named: "cc_tc_image"), for: .normal)
        btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 45.pix()
        table.showsVerticalScrollIndicator = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 16.pix()
        table.layer.masksToBounds = true
        
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
private extension PopSelectAuthListView {
    
    func setupUI() {
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(confirmBtn)
        bgImageView.addSubview(tableView)
    }
    
    func setupLayout() {
        bgImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 324.pix(), height: 420.pix()))
        }
        
        cancelBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.size.equalTo(18.pix())
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(37.pix())
            $0.height.equalTo(20)
        }
        
        confirmBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 274.pix(), height: 48.pix()))
            $0.bottom.equalTo(cancelBtn.snp.top).offset(-41.pix())
        }
        
        tableView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(11.pix())
            $0.right.equalToSuperview().offset(-11.pix())
            $0.top.equalTo(nameLabel.snp.bottom).offset(12.pix())
            $0.bottom.equalTo(confirmBtn.snp.top).offset(-10)
        }
    }
}

// MARK: - Action
private extension PopSelectAuthListView {
    
    @objc func cancelClick() {
        cancelBlock?()
    }
    
    @objc func confirmClick() {
        guard let index = selectedIndex else {
            ToastWindowManager.showMessage("Please select a certification item.".localized)
            return
        }
        confirmBlock?(modelArray[index])
    }
}

// MARK: - Selection Logic
private extension PopSelectAuthListView {
    
    func updateSelection(oldValue: Int?, newValue: Int?) {
        var reloadIndexPaths: [IndexPath] = []
        
        if let old = oldValue {
            reloadIndexPaths.append(IndexPath(row: old, section: 0))
        }
        if let new = newValue {
            reloadIndexPaths.append(IndexPath(row: new, section: 0))
        }
        
        tableView.reloadRows(at: reloadIndexPaths, with: .none)
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let model = modelArray[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.textLabel?.text = model.trueacle ?? ""
        
        if isSelected {
            let bg = UIView()
            bg.backgroundColor = UIColor(hexString: "#FAE351")
            cell.backgroundView = bg
            cell.textLabel?.textColor = UIColor(hexString: "#3D955E")
        } else {
            cell.backgroundView = nil
            cell.textLabel?.textColor = UIColor(hexString: "#6F7A75")
        }
    }
}

// MARK: - Public API
extension PopSelectAuthListView {
    
    func clearSelection() {
        selectedIndex = nil
    }
    
    func setDefaultSelection(at index: Int) {
        guard index < modelArray.count else { return }
        selectedIndex = index
    }
}

// MARK: - UITableView
extension PopSelectAuthListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}
