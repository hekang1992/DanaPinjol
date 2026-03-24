//
//  ToastManager.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import UIKit
import Toast_Swift

class ToastWindowManager {
    
    static func showMessage(_ message: String,
                            duration: TimeInterval = 2.0,
                            position: ToastPosition = .center) {
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: { $0.isKeyWindow }) else {
                return
            }
            
            var style = ToastStyle()
            style.messageFont = UIFont.systemFont(ofSize: 16, weight: .medium)
            style.cornerRadius = 10
            style.horizontalPadding = 10
            style.verticalPadding = 10
            style.messageColor = .white
            style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
            window.makeToast(message,
                             duration: duration,
                             position: position,
                             style: style)
        }
    }
}
