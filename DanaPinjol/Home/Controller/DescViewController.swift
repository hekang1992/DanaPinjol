//
//  DescViewController.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class DescViewController: BaseViewController {
    
    private let viewModel = MineViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "cp_bg_image")
        return descImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitle("Apply".localized, for: .normal)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        applyBtn.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
        return applyBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 48.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-5)
        }
        
        scrollView.addSubview(descImageView)
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 315.pix(), height: 474.pix()))
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        applyBtn
            .tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancellables)
        
    }
    
}

extension DescViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.confilgTitle("Product Compare".localized)
        
        headView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

