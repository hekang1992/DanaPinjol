//
//  PopSureCardMessageView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/19.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class PopSureCardMessageView: BaseView {
    
    var cancelBlock: (() -> Void)?
    
    var sureBlock: (() -> Void)?
    
    var tapTimeBlock: ((String) -> Void)?
    
    var model: cylindModel? {
        didSet {
            guard let model = model else { return }
            oneView.phoneTextFiled.text = model.trueacle ?? ""
            twoView.phoneTextFiled.text = model.hab ?? ""
            threeView.phoneTextFiled.text = model.tele ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "alc_info_a_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        nextBtn.setTitle("Confirm".localized, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextBtn.setBackgroundImage(UIImage(named: "con_a_i_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.text = "Confirm Identity Information".localized
        nameLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.text = "Please double-check your ID card information carefully, as it cannot be changed once submitted".localized
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.init(hexString: "#D91C29")
        descLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        return descLabel
    }()
    
    lazy var oneView: AppInputView = {
        let oneView = AppInputView(frame: .zero)
        oneView.bgImageView.image = UIImage(named: "name_cp_ic_image")
        oneView.nameLabel.text = "Real name".localized
        oneView.phoneTextFiled.placeholder = "Real name".localized
        return oneView
    }()
    
    lazy var twoView: AppInputView = {
        let twoView = AppInputView(frame: .zero)
        twoView.bgImageView.image = UIImage(named: "snu_cp_ic")
        twoView.nameLabel.text = "PAN number".localized
        twoView.phoneTextFiled.placeholder = "PAN number".localized
        return twoView
    }()
    
    lazy var threeView: AppTapView = {
        let threeView = AppTapView(frame: .zero)
        threeView.bgImageView.image = UIImage(named: "sjt_cp_ic")
        threeView.nameLabel.text = "Date of birth".localized
        threeView.phoneTextFiled.placeholder = "Date of birth".localized
        return threeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(nextBtn)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(descLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 324.pix(), height: 498.pix()))
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(18.pix())
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 274.pix(), height: 48.pix()))
            make.bottom.equalTo(cancelBtn.snp.top).offset(-41.pix())
        }
        
        descLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(38.pix())
            make.left.equalToSuperview().offset(16.pix())
            make.right.equalToSuperview().offset(-130.pix())
        }
        
        bgImageView.addSubview(oneView)
        bgImageView.addSubview(twoView)
        bgImageView.addSubview(threeView)
        
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(104.pix())
            make.left.right.equalToSuperview()
            make.height.equalTo(66.pix())
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(20.pix())
            make.left.right.equalToSuperview()
            make.height.equalTo(66.pix())
        }
        
        threeView.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(20.pix())
            make.left.right.equalToSuperview()
            make.height.equalTo(66.pix())
        }
        
        bindClickTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopSureCardMessageView {
    
    private func bindClickTap() {
        
        cancelBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.cancelBlock?()
            }
            .store(in: &cancellables)
        
        nextBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.sureBlock?()
            }
            .store(in: &cancellables)
        
        threeView.tapTimeBlock = { [weak self] time in
            self?.tapTimeBlock?(time)
        }
    }
    
}
