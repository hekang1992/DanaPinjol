//
//  OrderEmptyView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class OrderEmptyView: BaseView {
    
    var emptyBtnBlock: (() -> Void)?
    
    lazy var emptyBtn: UIButton = {
        let emptyBtn = UIButton(type: .custom)
        emptyBtn.setBackgroundImage(UIImage(named: "apc_on_bg_image".localized), for: .normal)
        emptyBtn.adjustsImageWhenHighlighted = false
        return emptyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(emptyBtn)
        emptyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 246.pix(), height: 234.pix()))
            }else {
                make.size.equalTo(CGSize(width: 223.pix(), height: 218.pix()))
            }
        }
        
        emptyBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.emptyBtnBlock?()
            }
            .store(in: &cancellables)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
