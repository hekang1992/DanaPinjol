//
//  MineToolsView.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

import UIKit
import SnapKit

class MineToolsView: BaseView {
    
    var modelArray: [stinguenceModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            setupListViews(with: modelArray)
        }
    }
    
    private var listViews: [MineListView] = []
    
    var tapBlock: ((String) -> Void)?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "Common tools".localized
        nameLabel.textColor = UIColor.init(hexString: "#082217")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15)
            make.height.equalTo(15)
        }
    }
    
    private func setupListViews(with models: [stinguenceModel]) {
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        for (index, model) in models.enumerated() {
            let listView = MineListView()
            listView.model = model
            addSubview(listView)
            listViews.append(listView)
            
            listView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(44)
                
                if index == 0 {
                    
                    make.top.equalToSuperview().offset(43)
                } else {

                    make.top.equalTo(listViews[index - 1].snp.bottom).offset(15)
                }
                
                if index == models.count - 1 {
                    make.bottom.equalToSuperview().offset(-15)
                }
            }
            
            listView.tapBlock = { [weak self] pageUrl in
                self?.tapBlock?(pageUrl)
            }
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
