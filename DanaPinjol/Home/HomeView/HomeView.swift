//
//  HomeView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit

class HomeView: BaseView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        return bgImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "line_head_image")
        descImageView.contentMode = .scaleAspectFill
        return descImageView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "home_en_head_image".localized)
        return oneImageView
    }()
    
    lazy var cardView: HomeCardView = {
        let cardView = HomeCardView()
        return cardView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "home_two_image".localized)
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "home_three_image".localized)
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "home_four_image".localized)
        return fourImageView
    }()
    
    lazy var indImageView: UIImageView = {
        let indImageView = UIImageView()
        indImageView.image = UIImage(named: "home_ind_two_image".localized)
        return indImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(descImageView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.pix())
            make.left.right.equalToSuperview()
            make.height.equalTo(441.pix())
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(oneImageView)
        contentView.addSubview(cardView)
        
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 166.pix()))
        }
        cardView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 295.pix()))
        }
        
        if LanguageManager.shared.getCurrentLanguage() == .indonesian {
            contentView.addSubview(indImageView)
            indImageView.snp.makeConstraints { make in
                make.top.equalTo(cardView.snp.bottom).offset(15)
                make.size.equalTo(CGSize(width: 335.pix(), height: 132.pix()))
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20.pix())
            }
        }else {
            contentView.addSubview(twoImageView)
            contentView.addSubview(threeImageView)
            contentView.addSubview(fourImageView)
            
            twoImageView.snp.makeConstraints { make in
                make.top.equalTo(cardView.snp.bottom).offset(15)
                make.size.equalTo(CGSize(width: 335.pix(), height: 80.pix()))
                make.centerX.equalToSuperview()
            }
            
            threeImageView.snp.makeConstraints { make in
                make.top.equalTo(twoImageView.snp.bottom).offset(15)
                make.size.equalTo(CGSize(width: 335.pix(), height: 127.pix()))
                make.centerX.equalToSuperview()
            }
            
            fourImageView.snp.makeConstraints { make in
                make.top.equalTo(threeImageView.snp.bottom).offset(15)
                make.size.equalTo(CGSize(width: 335.pix(), height: 294.pix()))
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20.pix())
            }
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
