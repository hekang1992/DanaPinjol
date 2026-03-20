//
//  ContractViewCell.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import SnapKit

class ContractViewCell: UITableViewCell {
    
    var oneBlock: (() -> Void)?
    
    var twoBlock: (() -> Void)?
    
    var model: actuallyifyModel? {
        didSet {
            guard let model = model else { return }
            
            nameLabel.text = model.sitlike ?? ""
            
            oneView.nameLabel.text = model.manuality ?? ""
            oneView.phoneTextFiled.placeholder = model.polyosity ?? ""
            
            twoView.nameLabel.text = model.ofial ?? ""
            twoView.phoneTextFiled.placeholder = model.matririseious ?? ""
            
            applyDefaultValue(from: model)
        }
    }
    
    private func applyDefaultValue(from model: actuallyifyModel) {
        guard
            let targetValue = model.ovilawose,
            let list = model.clysally
        else { return }
        
        if let matchedItem = list.first(where: { $0.pathyish == targetValue }) {
            oneView.phoneTextFiled.text = matchedItem.trueacle ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "mtc_ik_image")
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return nameLabel
    }()
    
    lazy var oneView: AppTapView = {
        let oneView = AppTapView()
        oneView.bgImageView.image = UIImage(named: "basic_infor_image")
        return oneView
    }()
    
    lazy var twoView: AppTapView = {
        let twoView = AppTapView()
        twoView.bgImageView.image = UIImage(named: "basic_infor_image")
        return twoView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(oneView)
        bgImageView.addSubview(twoView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 247.pix()))
            make.bottom.equalToSuperview().offset(-20)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15.pix())
            make.height.equalTo(15)
        }
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 320.pix(), height: 75.pix()))
        }
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(20.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 320.pix(), height: 75.pix()))
        }
        
        bindTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractViewCell {
    
    private func bindTap() {
        
        oneView.tapTimeBlock = { [weak self] _ in
            guard let self else { return }
            self.oneBlock?()
        }
        
        twoView.tapTimeBlock = { [weak self] _ in
            guard let self else { return }
            self.twoBlock?()
        }
        
    }
    
}
