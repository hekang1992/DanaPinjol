//
//  OrderViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class OrderViewController: BaseViewController {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        return bgImageView
    }()
    
    lazy var desImageView: UIImageView = {
        let desImageView = UIImageView()
        desImageView.image = UIImage(named: "occ_ad_image")
        return desImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(desImageView)
        desImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(142.pix())
        }
        
    }
    
    
}

extension OrderViewController {
    
    
    
}
