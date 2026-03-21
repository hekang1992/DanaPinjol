//
//  LoginViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Toast_Swift
import Combine

class LoginViewController: BaseViewController {
    
    private var countdownTimer: Timer?
    
    private var currentCount = 60
    
    private let totalCount = 60
    
    private let viewModel = LoginViewModel()
    
    private let pViewModel = ProductViewModel()
    
    private let locationManager = LocationManager()
    
    private var stime: String = ""
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.clickBtnBlock = { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .back_info:
                self.dismiss(animated: true)
                self.loginView.phoneTextFiled.resignFirstResponder()
                self.loginView.codeTextFiled.resignFirstResponder()
                
            case .policy_info:
                let pageUrl = h5_url + "/callfreewise"
                self.juduePageToVc(pageUrl)
                
            case .code_info:
                self.codeInfo()
                
            case .login_info:
                self.loginInfo()
            }
        }
        
        bindViewModel()
        
        stime = String(Int(Date().timeIntervalSince1970))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginView.phoneTextFiled.becomeFirstResponder()
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            locationInfo()
        }
    }
    
    private func locationInfo() {
        locationManager.requestLocation { _ in }
    }
    
}

extension LoginViewController {
    
    
    private func startCountdown() {
        stopCountdown()
        
        currentCount = totalCount
        updateCodeButtonTitle()
        loginView.codeBtn.isEnabled = false
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        resetCodeButton()
    }
    
    @objc private func updateCountdown() {
        currentCount -= 1
        
        if currentCount <= 0 {
            stopCountdown()
        } else {
            updateCodeButtonTitle()
        }
    }
    
    private func updateCodeButtonTitle() {
        let title = "\(currentCount)s"
        loginView.codeBtn.setTitle(title, for: .disabled)
    }
    
    private func resetCodeButton() {
        loginView.codeBtn.setTitle("Get code".localized, for: .normal)
        loginView.codeBtn.isEnabled = true
    }
    
}

extension LoginViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if viewModel.action == .code_info {
                        self.loginView.codeTextFiled.becomeFirstResponder()
                        self.startCountdown()
                    }
                    
                    if viewModel.action == .login_info {
                        let phone = model.cylind?.relatesion ?? ""
                        let token = model.cylind?.howfier ?? ""
                        LoginManager.shared.saveLoginInfo(phone: phone, token: token)
                        
                        self.dpAppInfo()
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                        }
                        
                    }
                    
                    
                }
                
                ToastWindowManager.showMessage(model.plurimon ?? "")
            }
            .store(in: &cancellables)
    }
    
    private func codeInfo() {
        guard let phone = loginView.phoneTextFiled.text, !phone.isEmpty else {
            ToastWindowManager.showMessage("Please enter your phone number".localized)
            return
        }
        let parameters = ["futuretion": phone,
                          "linqury": "1"]
        viewModel.codeInfo(parameters: parameters)
    }
    
    private func loginInfo() {
        
        self.loginView.codeTextFiled.resignFirstResponder()
        
        self.loginView.phoneTextFiled.resignFirstResponder()
        
        guard let phone = loginView.phoneTextFiled.text, !phone.isEmpty else {
            ToastWindowManager.showMessage("Please enter your phone number".localized)
            return
        }
        
        guard let code = loginView.codeTextFiled.text, !code.isEmpty else {
            ToastWindowManager.showMessage("Please enter the verification code".localized)
            return
        }
        
        guard loginView.isGrand else {
            ToastWindowManager.showMessage("Please read and confirm the privacy agreement".localized)
            return
        }
        let parameters = ["relatesion": phone,
                          "heative": code,
                          "canshe": "1"]
        viewModel.loginInfo(parameters: parameters)
    }
    
    private func dpAppInfo() {
        let parameters = ["noweer": "",
                          "scorear": "1",
                          "cultural": "",
                          "foss": stime,
                          "micrial": String(Int(Date().timeIntervalSince1970))]
        pViewModel.uploadPointInfo(parameters: parameters)
    }
    
}
