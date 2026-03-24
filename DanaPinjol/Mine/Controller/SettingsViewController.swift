//
//  SettingsViewController.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import TYAlertController

class SettingsViewController: BaseViewController {
    
    private let viewModel = MineViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "center_logo_image")
        return logoImageView
    }()
    
    lazy var versionView: MineListView = {
        let versionView = MineListView()
        versionView.rightImageView.isHidden = true
        versionView.iconImageView.image = UIImage(named: "version_icon_image")
        versionView.nameLabel.text = "Version".localized
        return versionView
    }()
    
    lazy var logoutView: MineListView = {
        let logoutView = MineListView()
        logoutView.iconImageView.image = UIImage(named: "out_icon_image")
        logoutView.nameLabel.text = "Log out".localized
        return logoutView
    }()
    
    lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.textAlignment = .right
        versionLabel.text = getAppVersion()
        versionLabel.textColor = UIColor.init(hexString: "#6F7A75")
        versionLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return versionLabel
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("Account cancellation", for: .normal)
        deleteBtn.setTitleColor(UIColor.init(hexString: "#6F7A75"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        deleteBtn.layer.cornerRadius = 9
        deleteBtn.layer.masksToBounds = true
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor.init(hexString: "#6F7A75").cgColor
        deleteBtn.backgroundColor = .white
        return deleteBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(30)
            make.width.height.equalTo(88)
        }
        
        view.addSubview(versionView)
        view.addSubview(logoutView)
        
        versionView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        logoutView.snp.makeConstraints { make in
            make.top.equalTo(versionView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        versionView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(30)
        }
        
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(20)
        }
        
        logoutView.tapBlock = { [weak self] _ in
            self?.alertLogoutView()
        }
        
        deleteBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.alertDeleteView()
            }.store(in: &cancellables)
        
        bindViewModel()
        
        deleteBtn.isHidden = LanguageManager.shared.getCurrentLanguage() == .indonesian ? true : false
    }
    
}

extension SettingsViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.confilgTitle("Set Up".localized)
        
        headView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func bindViewModel() {
        
        viewModel
            .$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    LoginManager.shared.clearLoginInfo()
                    self.dismiss(animated: true)
                    NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                }
                ToastWindowManager.showMessage(model.plurimon ?? "")
            }
            .store(in: &cancellables)
        
        viewModel
            .$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            }
            .store(in: &cancellables)
        
    }
}

extension SettingsViewController {
    
    private func alertLogoutView() {
        let logoutView = MineLogoutView(frame: self.view.bounds)
        guard let alertVc = TYAlertController(alert: logoutView, preferredStyle: .alert) else { return }
        self.present(alertVc, animated: true)
        
        logoutView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        logoutView.confirmBlock = { [weak self] in
            guard let self = self else { return }
            let phone = LoginManager.shared.getPhone() ?? ""
            let token = LoginManager.shared.getPhone() ?? ""
            let parameters = ["solen": phone, "whenier": token]
            viewModel.logoutInfo(parameters: parameters)
        }
    }
    
    private func alertDeleteView() {
        let deleteView = MineDeleteView(frame: self.view.bounds)
        guard let alertVc = TYAlertController(alert: deleteView, preferredStyle: .alert) else { return }
        self.present(alertVc, animated: true)
        
        deleteView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        deleteView.confirmBlock = { [weak self] in
            guard let self = self else { return }
            
            guard deleteView.clickCycleBtn.isSelected else {
                ToastWindowManager.showMessage("Please read and agree to the above")
                return
            }
            
            let phone = LoginManager.shared.getPhone() ?? ""
            let token = LoginManager.shared.getPhone() ?? ""
            let parameters = ["opportunity": phone, "whenier": token]
            viewModel.deleteInfo(parameters: parameters)
        }
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
}
