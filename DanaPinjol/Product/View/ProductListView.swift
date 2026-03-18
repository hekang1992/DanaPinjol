//
//  ProductListView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/18.
//

import UIKit
import SnapKit
import Kingfisher
import Combine
import CombineCocoa

class ProductListView: BaseView {
    
    var tapBlock: ((totalsomeModel) -> Void)?
    
    var model: totalsomeModel? {
        didSet {
            guard let model = model else { return }
            
            let logoUrl = model.tenacorium ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            
            nameLabel.text = model.hetercarryar ?? ""
            typeLabel.text = model.scal ?? ""
            
            let jug = model.jug ?? 0
            shieldImageView.image = jug == 1 ? UIImage(named: "cert_sel_image") : UIImage(named: "cert_nor_image")
            typeImageView.image = jug == 1 ? UIImage(named: "sc_icon_image") : UIImage(named: "ces_icon_image")
            typeLabel.textColor = jug == 1 ? UIColor.init(hexString: "#3D955E") : UIColor.init(hexString: "#6F7A75")
            
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        return bgView
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
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return nameLabel
    }()
    
    lazy var shieldImageView: UIImageView = {
        let shieldImageView = UIImageView()
        return shieldImageView
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .left
        typeLabel.numberOfLines = 0
        typeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return typeLabel
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        return typeImageView
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(typeImageView)
        bgView.addSubview(shieldImageView)
        bgView.addSubview(typeLabel)
        addSubview(tapBtn)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(logoImageView.snp.right).offset(13)
            make.height.equalTo(15)
        }
        typeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalToSuperview().offset(-15)
        }
        shieldImageView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 12, height: 14))
        }
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(shieldImageView)
            make.left.equalTo(shieldImageView.snp.right).offset(4)
            make.right.equalTo(typeImageView.snp.left).offset(-5)
        }
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bindTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductListView {
    
    private func bindTap() {
        tapBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, let model else { return }
                self.tapBlock?(model)
            }
            .store(in: &cancellables)
    }
    
}
