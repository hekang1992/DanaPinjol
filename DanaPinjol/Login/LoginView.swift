//
//  LoginView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit

class LoginView: UIView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "line_head_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
