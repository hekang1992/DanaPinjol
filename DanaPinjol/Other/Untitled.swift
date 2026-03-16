//
//  Untitled.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension CGFloat {
    func pix() -> CGFloat {
        return self / 375.0 * UIScreen.main.bounds.width
    }
}

extension Double {
    func pix() -> CGFloat {
        return CGFloat(self) / 375.0 * UIScreen.main.bounds.width
    }
}

extension Int {
    func pix() -> CGFloat {
        return CGFloat(self) / 375.0 * UIScreen.main.bounds.width
    }
}
