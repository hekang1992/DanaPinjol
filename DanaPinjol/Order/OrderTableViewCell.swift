//
//  OrderTableViewCell.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import SnapKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {
    
    var model: actuallyifyModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.octaneous ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.cofilman ?? ""
            typeLabel.text = model.military?.mulsule ?? ""
            
            let listArray = model.cladworry ?? []
            setupOrderListViews(with: listArray)
        }
    }
    
    private var orderListViews: [OrderListView] = []
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "oc_a_c_ad_image")
        bgImageView.isUserInteractionEnabled = true
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
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.init(hexString: "#3D955E")
        typeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return typeLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(typeLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 157.pix()))
            make.bottom.equalToSuperview().offset(-15)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22.pix())
            make.top.equalToSuperview().offset(10.pix())
            make.left.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(41.pix())
        }
    }
    
    private func setupOrderListViews(with listArray: [cladworryModel]) {
        orderListViews.forEach { $0.removeFromSuperview() }
        orderListViews.removeAll()
        
        let topOffset = 55.pix()
        let spacing: CGFloat = 5.pix()
        
        for (index, item) in listArray.enumerated() {
            let orderView = OrderListView()
            orderView.nameLabel.text = item.sitlike ?? ""
            orderView.numLabel.text = item.irasc ?? ""
            
            bgImageView.addSubview(orderView)
            
            orderView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(20.pix())
                
                if index == 0 {
                    make.top.equalToSuperview().offset(topOffset)
                    orderView.numLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                } else {
                    let previousView = orderListViews[index - 1]
                    make.top.equalTo(previousView.snp.bottom).offset(spacing)
                    orderView.numLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                }
            }
            
            orderListViews.append(orderView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        orderListViews.forEach { $0.removeFromSuperview() }
        orderListViews.removeAll()
        logoImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
    }
}
