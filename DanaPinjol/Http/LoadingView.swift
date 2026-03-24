//
//  LoadingView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    static let shared = LoadingView()
    
    private let grayView = UIView()
    private let containerView = UIView()
    private let indicator = UIActivityIndicatorView(style: .large)
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoadingView {
    
    func setupUI() {
        
        backgroundColor = .clear
        
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(grayView)
        
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        
        containerView.addSubview(indicator)
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension LoadingView {
    
    static func show() {
        
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow })
        else { return }
        
        let loading = LoadingView.shared
        
        if loading.superview != nil { return }
        
        window.addSubview(loading)
        
        loading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loading.indicator.startAnimating()
    }
    
    static func hide() {
        
        let loading = LoadingView.shared
        
        loading.indicator.stopAnimating()
        loading.removeFromSuperview()
    }
}
