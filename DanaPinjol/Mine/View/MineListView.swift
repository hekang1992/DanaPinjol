//
//  MineListView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Kingfisher
import Combine
import CombineCocoa

class MineListView: BaseView {
    
    var tapBlock: ((String) -> Void)?
    
    var model: stinguenceModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.silvi ?? ""
            iconImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.hetercarryar ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 9
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        return bgView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        return rightImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return nameLabel
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(rightImageView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(nameLabel)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 7, height: 12))
            make.right.equalToSuperview().offset(-12)
        }
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
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

extension MineListView {
    
    private func bindTap() {
        tapBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let pageUrl = model?.norster ?? ""
                self.tapBlock?(pageUrl)
            }
            .store(in: &cancellables)
    }
    
}
