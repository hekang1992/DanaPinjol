//
//  AppHeadView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class AppHeadView: BaseView {
    
    var onBackButtonTapped: (() -> Void)?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "app_back_image"), for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#082217")
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindActions()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confilgTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setBackButtonHidden(_ hidden: Bool) {
        backButton.isHidden = hidden
    }
    
    func setBackButtonImage(_ image: UIImage?) {
        backButton.setBackgroundImage(image, for: .normal)
    }
}

private extension AppHeadView {
    
    func setupUI() {
        setupBackgroundView()
        setupBackButton()
        setupTitleLabel()
    }
    
    func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBackButton() {
        backgroundView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(18.pix())
        }
    }
    
    func setupTitleLabel() {
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250.pix(), height: 30.pix()))
        }
    }
}

private extension AppHeadView {
    
    func bindActions() {
        backButton.tapPublisher
            .sink { [weak self] _ in
                self?.onBackButtonTapped?()
            }
            .store(in: &cancellables)
    }
}

private extension AppHeadView {
    
    enum Constants {
        static let backButtonSize: CGFloat = 18
        static let backButtonLeftOffset: CGFloat = 20
        static let titleLabelWidth: CGFloat = 250
        static let titleLabelHeight: CGFloat = 30
    }
}
