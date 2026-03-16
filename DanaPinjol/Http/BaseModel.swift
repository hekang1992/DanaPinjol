//
//  BaseModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

class BaseModel: Codable {
    var lentfier: String?
    var plurimon: String?
    var cylind: cylindModel?
    
    private enum CodingKeys: String, CodingKey {
        case lentfier, plurimon, cylind
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intValue = try? container.decode(Int.self, forKey: .lentfier) {
            lentfier = String(intValue)
        } else {
            lentfier = try? container.decode(String.self, forKey: .lentfier)
        }
        
        plurimon = try? container.decode(String.self, forKey: .plurimon)
        
        cylind = try? container.decode(cylindModel.self, forKey: .cylind)
    }
    
}

class cylindModel: Codable {
    var probablyar: String?
    var howfier: String?
    var relatesion: String?
    var discussship: discussshipModel?
}

class discussshipModel: Codable {
    var myee: String?
    var trialition: String?
    var naturalably: String?
    var toughture: String?
}
