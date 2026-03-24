//
//  AppInputViewCell.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/19.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class AppInputViewCell: UITableViewCell {
    
    var model: ludModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.hetercarryar ?? ""
            phoneTextFiled.placeholder = model.vetory ?? ""
            let coveresque = model.coveresque ?? ""
            phoneTextFiled.keyboardType = coveresque == "1" ? .numberPad : .default
            
            let value = model.irasc ?? ""
            phoneTextFiled.text = value
            
        }
    }
    
    var onTextChange: ((String) -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    var textPublisher: AnyPublisher<String, Never> {
        return phoneTextFiled.textPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "basicinf_ic")
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupUI()
        setupTextFieldListener()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(bgImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(phoneTextFiled)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20.pix())
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
            make.left.equalToSuperview().inset(20.pix())
            make.height.equalTo(40.pix())
            make.bottom.equalToSuperview().offset(-20)
        }
        phoneTextFiled.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    private func setupTextFieldListener() {
        phoneTextFiled.textPublisher
            .compactMap { $0 }
            .sink { [weak self] text in
                print("输入的文本: \(text)")
                self?.onTextChange?(text)
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
}
