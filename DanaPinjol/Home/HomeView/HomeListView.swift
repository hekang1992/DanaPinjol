//
//  HomeListView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit

class HomeListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#6F7A75")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .right
        numLabel.textColor = UIColor.init(hexString: "#082217")
        numLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20.pix())
            make.height.equalTo(15.pix())
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalToSuperview().offset(-20.pix())
            make.height.equalTo(15.pix())
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
