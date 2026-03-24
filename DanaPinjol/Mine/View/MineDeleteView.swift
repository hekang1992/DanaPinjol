//
//  MineDeleteView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class MineDeleteView: BaseView {
    
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "delete_icon_image".localized)
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton(type: .custom)
        return confirmBtn
    }()
    
    lazy var clickCycleBtn: UIButton = {
        let clickCycleBtn = UIButton(type: .custom)
        clickCycleBtn.setImage(UIImage(named: "po_nor_image"), for: .normal)
        clickCycleBtn.setImage(UIImage(named: "po_sel_image"), for: .selected)
        return clickCycleBtn
    }()
    
    lazy var policyLabel: UILabel = {
        let policyLabel = UILabel()
        policyLabel.textAlignment = .left
        policyLabel.text = "I have read and agree to the above"
        policyLabel.textColor = UIColor.init(hexString: "#3D955E")
        policyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return policyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 324.pix(), height: 392.pix()))
        }
        
        bgImageView.addSubview(confirmBtn)
        
        bgImageView.addSubview(cancelBtn)
        
        confirmBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(73.pix())
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.top).offset(-15.pix())
            make.height.equalTo(48.pix())
        }
        
        bgImageView.addSubview(clickCycleBtn)
        bgImageView.addSubview(policyLabel)
        
        clickCycleBtn.snp.makeConstraints { make in
            make.width.height.equalTo(12.pix())
            make.left.equalToSuperview().offset(51.pix())
            make.bottom.equalTo(cancelBtn.snp.top).offset(-15.pix())
        }
        
        policyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clickCycleBtn)
            make.left.equalTo(clickCycleBtn.snp.right).offset(5)
            make.height.equalTo(14.pix())
        }
        
        bindClickTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MineDeleteView {
    
    private func bindClickTap() {
        
        cancelBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.cancelBlock?()
            }.store(in: &cancellables)
        
        confirmBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.confirmBlock?()
            }.store(in: &cancellables)
        
        clickCycleBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.clickCycleBtn.isSelected.toggle()
            }.store(in: &cancellables)
        
    }
}
