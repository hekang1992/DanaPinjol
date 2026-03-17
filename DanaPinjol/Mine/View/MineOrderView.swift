//
//  MineOrderView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

enum MineClickOrderType: String {
    case all = "4"
    case progress = "7"
    case repayment = "6"
    case finish = "5"
    case policy
}

class MineOrderView: BaseView {
    
    var clickBtnBlock: ((MineClickOrderType) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "en_oc_image".localized)
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        return fourBtn
    }()
    
    lazy var fiveBtn: UIButton = {
        let fiveBtn = UIButton(type: .custom)
        return fiveBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.addSubview(threeBtn)
        bgImageView.addSubview(fourBtn)
        bgImageView.addSubview(fiveBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 202.pix()))
        }
        
        oneBtn.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(28.pix())
        }
        
        twoBtn.snp.makeConstraints { make in
            make.height.equalTo(74.pix())
            make.left.equalToSuperview()
            make.top.equalTo(oneBtn.snp.bottom)
            make.width.equalTo(106.pix())
        }
        
        threeBtn.snp.makeConstraints { make in
            make.left.equalTo(twoBtn.snp.right).offset(9.pix())
            make.height.equalTo(74.pix())
            make.top.equalTo(oneBtn.snp.bottom)
            make.width.equalTo(106.pix())
        }
        
        fourBtn.snp.makeConstraints { make in
            make.left.equalTo(threeBtn.snp.right).offset(9.pix())
            make.height.equalTo(74.pix())
            make.top.equalTo(oneBtn.snp.bottom)
            make.width.equalTo(106.pix())
        }
        
        fiveBtn.snp.makeConstraints { make in
            make.top.equalTo(twoBtn.snp.bottom).offset(20.pix())
            make.left.right.bottom.equalToSuperview()
        }
        
        bindClickTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MineOrderView {
    
    private func bindClickTap() {
        
        oneBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.all)
            }
            .store(in: &cancellables)
        
        twoBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.progress)
            }
            .store(in: &cancellables)
        
        threeBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.repayment)
            }
            .store(in: &cancellables)
        
        fourBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.finish)
            }
            .store(in: &cancellables)
        
        fiveBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clickBtnBlock?(.policy)
            }
            .store(in: &cancellables)
        
    }
    
}
