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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(nextBtn)
        
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
        
    }
    
}
