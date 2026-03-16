//
//  HomeViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import CombineCocoa
import Combine
import SnapKit

class HomeViewController: BaseViewController {
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in", for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginBtn
            .tapPublisher
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.toLoginPage()
            }.store(in: &cancellables)
        
    }
    
}


