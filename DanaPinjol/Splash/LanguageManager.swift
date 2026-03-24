//
//  LanguageManager.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Foundation

class LanguageManager {
    
    static let shared = LanguageManager()
    
    enum Language: String {
        case english = "en"
        case indonesian = "id"
        
        var serverCode: String {
            switch self {
            case .english:
                return "236"
                
            case .indonesian:
                return "235"
            }
        }
        
        static func fromServerCode(_ code: String) -> Language {
            switch code {
            case "235":
                return .indonesian
                
            case "236":
                return .english
                
            default:
                return .english
            }
        }
    }
    
    private var currentBundle: Bundle?
    
    private let userDefaultsKey = "AppLanguage"
    
    private init() {
        let savedLanguageCode = UserDefaults.standard.string(forKey: userDefaultsKey) ?? "en"
        setLanguage(Language(rawValue: savedLanguageCode) ?? .english)
    }
    
    func getCurrentLanguage() -> Language {
        guard let languageCode = UserDefaults.standard.string(forKey: userDefaultsKey),
              let language = Language(rawValue: languageCode) else {
            return .english
        }
        return language
    }
    
    func getCurrentLanguageCode() -> String {
        return getCurrentLanguage().serverCode
    }
    
    func setLanguageFromServerCode(_ code: String) {
        let language = Language.fromServerCode(code)
        setLanguage(language)
    }
    
    private func setLanguage(_ language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        setLanguageBundle(language)
    }
    
    private func setLanguageBundle(_ language: Language) {
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") {
            currentBundle = Bundle(path: path)
        } else {
            currentBundle = Bundle.main
        }
    }
    
    func localizedString(for key: String) -> String {
        return currentBundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
