//
//  URLParameterHelper.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Foundation
import UIKit
import AdSupport
import DeviceKit
import KeychainSwift

class URLParameterHelper {
    
    static let shared = URLParameterHelper()
    private let keychain = KeychainSwift()
    
    private init() {
        keychain.synchronizable = false
    }
    
    func getAllParameters() -> [String: String] {
        return [
            "theia": getAppVersion(),
            "oedern": getDeviceName(),
            "ethmsure": IDFVHelper.getStoredIDFV(),
            "sponsparentful": getOSVersion(),
            "howfier": "",
            "rogfication": IDFVHelper.getStoredIDFV(),
            "probablyar": getCurrentLanguage(),
            "lucidite": IDFVHelper.getIDFA()
        ]
    }
    
    func getFullURL(baseURL: String) -> String {
        
        guard var components = URLComponents(string: baseURL) else {
            return baseURL
        }
        
        let params = getAllParameters()
        
        var queryItems = components.queryItems ?? []
        
        for (key, value) in params {
            let item = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        return components.url?.absoluteString ?? baseURL
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private func getDeviceName() -> String {
        return Device.current.description
    }
    
    private func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private func getCurrentLanguage() -> String {
        return ""
    }
    
}

struct IDFVHelper {
    
    private static let keychain = KeychainSwift()
    private static let idfvKey = "com.yourapp.uniqueIDFV"
    
    static func getStoredIDFV() -> String {
        if let storedIDFV = keychain.get(idfvKey) {
            return storedIDFV
        }
        
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            keychain.set(idfv, forKey: idfvKey)
            return idfv
        }
        
        let fallbackIDFV = UUID().uuidString
        keychain.set(fallbackIDFV, forKey: idfvKey)
        return fallbackIDFV
    }
    
    static func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
}
