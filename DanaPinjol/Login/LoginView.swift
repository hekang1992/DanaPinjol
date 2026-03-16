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

class LoginView: BaseView {
    
    var backBlock: (() -> Void)?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(backBtn)
        
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
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.backBlock?()
            }
            .store(in: &cancellables)
        
    }
    
}
