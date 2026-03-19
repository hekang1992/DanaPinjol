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
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in to Zoom Loan", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginBtn.tapPublisher.sink { _ in
            self.showDatePicker()
        }.store(in: &cancellables)
        
    }
    
    
}

extension OrderViewController {
    
    @objc private func showDatePicker() {
        
        let datePicker = DatePickerView(dateString: "23/08/1985")
        
        datePicker.onDateSelected = { [weak self] dateString in
            
            print("选择的日期：\(dateString)")
        }
        
        datePicker.onDismiss = {
            print("日期选择器已关闭")
        }
        
        datePicker.show()
    }
    
}
