//
//  LoginManager.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Foundation

class LoginManager {
    
    static let shared = LoginManager()
    
    private init() {}
    
    private let phoneKey = "saved_phone"
    
    private let tokenKey = "saved_token"
    
    private let userDefaults = UserDefaults.standard
    
    func saveLoginInfo(phone: String, token: String) {
        userDefaults.set(phone, forKey: phoneKey)
        userDefaults.set(token, forKey: tokenKey)
        userDefaults.synchronize()
    }
    
    func getPhone() -> String? {
        return userDefaults.string(forKey: phoneKey)
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    func isLoggedIn() -> Bool {
        guard let phone = getPhone(), !phone.isEmpty,
              let token = getToken(), !token.isEmpty else {
            return false
        }
        return true
    }
    
    func clearLoginInfo() {
        userDefaults.removeObject(forKey: phoneKey)
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.synchronize()
    }
    
}
