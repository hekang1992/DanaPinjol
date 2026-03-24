//
//  ProductCardView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/18.
//

import UIKit
import SnapKit
import Kingfisher

class ProductCardView: BaseView {
    
    var model: seishModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.octaneous ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.cofilman ?? ""
            descLabel.text = model.acutorium ?? ""
            moneyLabel.text = model.onomasify ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "pd_head_image")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(descLabel)
        bgImageView.addSubview(moneyLabel)
        
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
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
