//
//  PopDpaView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/22.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class PopDpaView: BaseView {
    
    // MARK: - Public Properties
    var cancelBlock: (() -> Void)?
    var confirmBlock: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ind_pc_a_image".localized)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    private lazy var cancel1Btn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    private lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindClickTap()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(bgImageView)
        bgImageView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(cancelBtn)
        buttonStackView.addArrangedSubview(confirmBtn)
        
        bgImageView.addSubview(cancel1Btn)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 324.pix(), height: 376.pix()))
        }
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.height.equalTo(73.pix())
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(48.pix())
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15.pix())
        }
        
        cancel1Btn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(18.pix())
        }
    }
    
    // MARK: - Private Methods
    private func bindClickTap() {
        cancelBtn.tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cancelBlock?()
            }
            .store(in: &cancellables)
        
        cancel1Btn.tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cancelBlock?()
            }
            .store(in: &cancellables)
        
        confirmBtn.tapPublisher
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.confirmBlock?()
            }
            .store(in: &cancellables)
    }
}
