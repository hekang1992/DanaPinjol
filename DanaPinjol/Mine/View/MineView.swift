//
//  MineView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit

class MineView: BaseView {
    
    var clickBtnBlock: ((MineClickOrderType) -> Void)?
    
    var tapBlock: ((String) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "mine_head_image")
        headImageView.contentMode = .scaleAspectFill
        return headImageView
    }()
    
    lazy var haloImageView: UIImageView = {
        let haloImageView = UIImageView()
        haloImageView.image = UIImage(named: "Hello_image".localized)
        haloImageView.contentMode = .scaleAspectFit
        return haloImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        let number = LoginManager.shared.getPhone() ?? ""
        phoneLabel.text = maskPhoneNumberRegex(number: number)
        phoneLabel.textColor = UIColor.init(hexString: "#F8F5F0")
        phoneLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return phoneLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "mine_icon_image")
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var orderListView: MineOrderView = {
        let orderListView = MineOrderView()
        return orderListView
    }()
    
    lazy var toolsView: MineToolsView = {
        let toolsView = MineToolsView(frame: .zero)
        toolsView.layer.cornerRadius = 12
        toolsView.layer.masksToBounds = true
        toolsView.layer.borderWidth = 1
        toolsView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        return toolsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindTap()
    }
    
    private func setupUI() {
        addSubview(bgImageView)
        addSubview(headImageView)
        addSubview(haloImageView)
        addSubview(phoneLabel)
        addSubview(iconImageView)
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(orderListView)
        contentView.addSubview(toolsView)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(230.pix())
        }
        
        haloImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(70)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(haloImageView.snp.bottom).offset(15)
            make.left.equalTo(haloImageView)
            make.height.equalTo(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(54)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(96)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        orderListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(202.pix())
        }
        
        toolsView.snp.makeConstraints { make in
            make.top.equalTo(orderListView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20.pix())
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MineView {
    
    private func bindTap() {
        orderListView.clickBtnBlock = { [weak self] type in
            self?.clickBtnBlock?(type)
        }
        
        toolsView.tapBlock = { [weak self] pageUrl in
            self?.tapBlock?(pageUrl)
        }
    }
    
    func maskPhoneNumberRegex(number: String) -> String {
        guard number.count >= 5 else { return number }
        let prefix = String(number.prefix(2))
        let suffix = String(number.suffix(3))
        let maskedCount = number.count - 5
        return prefix + String(repeating: "*", count: maskedCount) + suffix
    }
    
    func updateToolsView(with models: [stinguenceModel]) {
        toolsView.modelArray = models
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
