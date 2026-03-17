//
//  HomeCardView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit
import Kingfisher

class HomeCardView: BaseView {
    
    var model: oesophaglessModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.octaneous ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.cofilman ?? ""
            descLabel.text = model.institutionance ?? ""
            moneyLabel.text = model.economyical ?? ""
            applyBtn.setTitle(model.termitmarketative ?? "", for: .normal)
            
            oneView.nameLabel.text = model.histriule ?? ""
            oneView.numLabel.text = model.emeticad ?? ""
            
            twoView.nameLabel.text = model.figmost ?? ""
            twoView.numLabel.text = model.themselveseur ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_card_icon_image")
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return descLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        moneyLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return moneyLabel
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(UIColor.init(hexString: "#082217"), for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        applyBtn.setBackgroundImage(UIImage(named: "apply_click_image"), for: .normal)
        return applyBtn
    }()
    
    lazy var oneView: HomeListView = {
        let oneView = HomeListView(frame: .zero)
        return oneView
    }()
    
    lazy var twoView: HomeListView = {
        let twoView = HomeListView(frame: .zero)
        return twoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(descLabel)
        bgImageView.addSubview(moneyLabel)
        bgImageView.addSubview(applyBtn)
        bgImageView.addSubview(oneView)
        bgImageView.addSubview(twoView)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(28.pix())
            make.top.equalToSuperview().offset(16.pix())
            make.left.equalToSuperview().offset(19)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(14.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(35.pix())
            make.size.equalTo(CGSize(width: 295.pix(), height: 48.pix()))
            make.centerX.equalToSuperview()
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(applyBtn.snp.bottom).offset(30)
            make.height.equalTo(16.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(10)
            make.height.equalTo(16.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
