//
//  LoginView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

enum LoginClickType: String {
    case back_info = "1"
    case policy_info
    case code_info
    case login_info
}

class LoginView: BaseView {
    
    var clickBtnBlock: ((LoginClickType) -> Void)?
    
    @Published var isGrand: Bool = true
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "line_head_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setBackgroundImage(UIImage(named: "app_back_image"), for: .normal)
        return backBtn
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "login_desc_en_image".localized)
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.layer.cornerRadius = 12
        oneView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        oneView.layer.borderWidth = 1
        oneView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        oneView.layer.masksToBounds = true
        return oneView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.text = "+91".localized
        oneLabel.textColor = UIColor.init(hexString: "#3D955E")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return oneLabel
    }()
    
    lazy var lineImageView: UIImageView = {
        let lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "dot_line_image")
        return lineImageView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.placeholder = "Login mobile number".localized
        phoneTextFiled.keyboardType = .numberPad
        phoneTextFiled.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        phoneTextFiled.textColor = UIColor.init(hexString: "#082217")
        return phoneTextFiled
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.layer.cornerRadius = 12
        twoView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        twoView.layer.borderWidth = 1
        twoView.layer.borderColor = UIColor.init(hexString: "#082217").cgColor
        twoView.layer.masksToBounds = true
        return twoView
    }()
    
    lazy var twoLineImageView: UIImageView = {
        let twoLineImageView = UIImageView()
        twoLineImageView.image = UIImage(named: "dot_line_image")
        return twoLineImageView
    }()
    
    lazy var codeTextFiled: UITextField = {
        let codeTextFiled = UITextField()
        codeTextFiled.placeholder = "Verification code".localized
        codeTextFiled.keyboardType = .numberPad
        codeTextFiled.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        codeTextFiled.textColor = UIColor.init(hexString: "#082217")
        return codeTextFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle("Get code".localized, for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        codeBtn.backgroundColor = UIColor.init(hexString: "#3D955E")
        return codeBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in".localized, for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var clickCycleBtn: UIButton = {
        let clickCycleBtn = UIButton(type: .custom)
        clickCycleBtn.setImage(UIImage(named: "po_nor_image"), for: .normal)
        clickCycleBtn.setImage(UIImage(named: "po_sel_image"), for: .selected)
        clickCycleBtn.isSelected = true
        clickCycleBtn.adjustsImageWhenHighlighted = false
        return clickCycleBtn
    }()
    
    lazy var policyBtn: UIButton = {
        let policyBtn = UIButton(type: .custom)
        policyBtn.setBackgroundImage(UIImage(named: "login_policy_en_image".localized), for: .normal)
        return policyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(backBtn)
        addSubview(oneImageView)
        addSubview(oneView)
        oneView.addSubview(oneLabel)
        oneView.addSubview(lineImageView)
        oneView.addSubview(phoneTextFiled)
        
        addSubview(twoView)
        twoView.addSubview(codeBtn)
        twoView.addSubview(twoLineImageView)
        twoView.addSubview(codeTextFiled)
        
        addSubview(loginBtn)
        addSubview(clickCycleBtn)
        addSubview(policyBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(441.pix())
        }
        
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(13)
            make.left.equalToSuperview().offset(20)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(110.pix())
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(44)
        }
        
        oneView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(34)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(46)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(47)
        }
        
        lineImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(oneLabel.snp.right)
            make.width.equalTo(1.pix())
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.equalTo(lineImageView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-2)
        }
        
        twoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(46)
        }
        
        codeBtn.snp.makeConstraints { make in
            make.bottom.top.right.equalToSuperview()
            make.width.equalTo(83.pix())
        }
        
        twoLineImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1.pix())
            make.right.equalTo(codeBtn.snp.left)
        }
        
        codeTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(twoLineImageView.snp.left).offset(-20)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom).offset(46)
            make.size.equalTo(CGSize(width: 315.pix(), height: 48.pix()))
        }
        
        clickCycleBtn.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.top.equalTo(loginBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(33.pix())
        }
        
        policyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(clickCycleBtn)
            make.left.equalTo(clickCycleBtn.snp.right).offset(6)
        }
        
        bindTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    private func bindTap() {
        
        backBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.back_info)
            }
            .store(in: &cancellables)
        
        policyBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.policy_info)
            }
            .store(in: &cancellables)
        
        clickCycleBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickCycleBtn.isSelected.toggle()
                self?.isGrand = self?.clickCycleBtn.isSelected ?? true
            }
            .store(in: &cancellables)
        
        codeBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.code_info)
            }
            .store(in: &cancellables)
        
        loginBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.login_info)
            }
            .store(in: &cancellables)
    }
    
}
