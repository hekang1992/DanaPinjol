//
//  HomeProductListViewCell.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import SnapKit
import Kingfisher
import Combine
import CombineCocoa

class HomeProductListViewCell: UITableViewCell {
    
    var cancellables = Set<AnyCancellable>()
    
    var tapProductBlock: ((String) -> Void)?
    
    var model: oesophaglessModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.octaneous ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.cofilman ?? ""
            descLabel.text = model.institutionance ?? ""
            moneyLabel.text = model.economyical ?? ""
            ntcLabel.text = model.termitmarketative ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "pdo_bg_image")
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
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return nameLabel
    }()
    
    lazy var hotImageView: UIImageView = {
        let hotImageView = UIImageView()
        hotImageView.image = UIImage(named: "loan_super_image")
        return hotImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.init(hexString: "#6F7A75")
        descLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return descLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#082217")
        moneyLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return moneyLabel
    }()
    
    lazy var tcImageView: UIImageView = {
        let tcImageView = UIImageView()
        tcImageView.image = UIImage(named: "ap_c_im_age")
        return tcImageView
    }()
    
    lazy var ntcLabel: UILabel = {
        let ntcLabel = UILabel()
        ntcLabel.textAlignment = .center
        ntcLabel.textColor = .white
        ntcLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return ntcLabel
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(hotImageView)
        bgImageView.addSubview(descLabel)
        bgImageView.addSubview(moneyLabel)
        bgImageView.addSubview(tcImageView)
        tcImageView.addSubview(ntcLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 101.pix()))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.pix())
            make.left.equalToSuperview().offset(15.pix())
            make.width.height.equalTo(22.pix())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        hotImageView.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(nameLabel.snp.right).offset(8.pix())
            make.width.height.equalTo(14)
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.pix())
            make.top.equalToSuperview().offset(52.pix())
            make.height.equalTo(14)
        }
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(5.pix())
            make.height.equalTo(20)
        }
        tcImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 122.pix(), height: 38.pix()))
        }
        ntcLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(tapBtn)
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bindTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeProductListViewCell {
    
    private func bindTap() {
        
        tapBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, let model else { return }
                self.tapProductBlock?(String(model.side ?? 0))
            }
            .store(in: &cancellables)
    }
}
