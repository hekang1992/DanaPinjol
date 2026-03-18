//
//  PopAlertCardView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/18.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class PopAlertCardView: BaseView {
    
    var cancelBlock: (() -> Void)?
    
    var sureBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(sureBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 324.pix(), height: 457.pix()))
        }
        cancelBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(15.pix())
        }
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(cancelBtn.snp.top).offset(-41.pix())
            make.height.equalTo(48.pix())
        }
        
        bindClickTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopAlertCardView {
    
    private func bindClickTap() {
        
        cancelBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.cancelBlock?()
            }
            .store(in: &cancellables)
        
        sureBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.sureBlock?()
            }
            .store(in: &cancellables)
        
    }
    
}
