//
//  OrderListView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/20.
//

import UIKit
import SnapKit

class OrderListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#6F7A75")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .right
        numLabel.textColor = UIColor.init(hexString: "#082217")
        numLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return numLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(numLabel)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        numLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
