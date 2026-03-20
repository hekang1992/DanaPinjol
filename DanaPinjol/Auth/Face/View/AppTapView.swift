//
//  AppTapView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/19.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class AppTapView: BaseView {
    
    var tapTimeBlock: ((String) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return nameLabel
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.isEnabled = false
        phoneTextFiled.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        phoneTextFiled.textColor = UIColor.init(hexString: "#082217")
        return phoneTextFiled
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        return bgView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "right_b_c_image")
        return iconImageView
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(nameLabel)
        addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(phoneTextFiled)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.width.height.equalTo(14)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bgImageView)
            make.left.equalTo(bgImageView.snp.right).offset(5)
            make.height.equalTo(14)
        }
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(40.pix())
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 7, height: 12))
        }
        phoneTextFiled.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(iconImageView.snp.left).offset(-10)
        }
        
        addSubview(tapBtn)
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bindTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AppTapView {
    
    private func bindTap() {
        
        tapBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.tapTimeBlock?(self.phoneTextFiled.text ?? "")
            }
            .store(in: &cancellables)
    }
    
}
