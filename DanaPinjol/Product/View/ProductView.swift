//
//  ProductView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/18.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

enum StepClickType: String {
    case cell = "1"
    case next
}

class ProductView: BaseView {
    
    var tapBlock: ((totalsomeModel, cylindModel, StepClickType) -> Void)?
    
    var model: cylindModel? {
        didSet {
            guard let model = model else { return }
            cardView.model = model.seish
            
            if let stepModel = model.priviical {
                let typeStr = stepModel.medi ?? ""
                if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                    let imageStr = String(format: "ind_%@_icon", typeStr)
                    typeImageView.image = UIImage(named: imageStr)
                }else {
                    let imageStr = String(format: "en_%@_icon", typeStr)
                    typeImageView.image = UIImage(named: imageStr)
                }
            }else {
                if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                    let imageStr = String(format: "ind_%@_icon", "dudom")
                    typeImageView.image = UIImage(named: imageStr)
                }else {
                    let imageStr = String(format: "en_%@_icon", "dudom")
                    typeImageView.image = UIImage(named: imageStr)
                }
            }
            
            let nextStr = model.seish?.termitmarketative ?? ""
            self.nextBtn.setTitle(nextStr, for: .normal)
            
            let listArray = model.totalsome ?? []
            setupListViews(with: listArray)
        }
    }
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextBtn.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var cardView: ProductCardView = {
        let cardView = ProductCardView()
        return cardView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "Certification process".localized
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        return nameLabel
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        return typeImageView
    }()
    
    private var listViews: [ProductListView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindTap()
    }
    
    private func setupUI() {
        
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.size.equalTo(CGSize(width: 315.pix(), height: 48.pix()))
        }
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(cardView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeImageView)
        
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 164.pix()))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.left.equalTo(cardView)
            make.height.equalTo(16)
        }
        typeImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20.pix())
            make.width.equalTo(31)
        }
    }
    
    private func setupListViews(with items: [totalsomeModel]) {
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        guard !items.isEmpty else { return }
        
        var previousView: ProductListView?
        
        for (index, item) in items.enumerated() {
            let listView = ProductListView()
            listView.model = item
            contentView.addSubview(listView)
            listViews.append(listView)
            
            listView.tapBlock = { [weak self] listModel in
                guard let self, let model else { return }
                self.tapBlock?(listModel, model, .cell)
            }
            
            listView.snp.makeConstraints { make in
                make.top.equalTo(previousView?.snp.bottom ?? nameLabel.snp.bottom).offset(previousView == nil ? 20 : 15)
                make.right.equalTo(cardView)
                make.size.equalTo(CGSize(width: 296.pix(), height: 58))
                
                if index == items.count - 1 {
                    make.bottom.equalToSuperview().offset(-15)
                }
            }
            
            previousView = listView
        }
        
        contentView.layoutIfNeeded()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductView {
    
    private func bindTap() {
        nextBtn
            .tapPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self,
                      let model = model else { return }
                self.tapBlock?(model.priviical ?? totalsomeModel(), model, .next)
            }
            .store(in: &cancellables)
    }
    
}
