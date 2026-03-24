//
//  BaseModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
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
    var stinguence: [stinguenceModel]?
    var actuallyify: [actuallyifyModel]?
    var thero: String?
    var seish: seishModel?
    var totalsome: [totalsomeModel]?
    var priviical: totalsomeModel?
    var terraetic: terraeticModel?
    var rockeur: terraeticModel?
    var tele: String?
    var hab: String?
    var trueacle: String?
    var fodment: Int?
    var lud: [ludModel]?
    var college: collegeModel?
    var emulable: String?
}

class discussshipModel: Codable {
    var myee: String?
    var trialition: String?
    var naturalably: String?
    var toughture: String?
}

class stinguenceModel: Codable {
    var hetercarryar: String?
    var silvi: String?
    var norster: String?
}

class actuallyifyModel: Codable {
    var pathyish: String?
    var oesophagless: [oesophaglessModel]?
    var ovilawose: String?
    var trueacle: String?
    var misoile: String?
    var tendivity: String?
    var sitlike: String?
    var matririseious: String?
    var ofial: String?
    var polyosity: String?
    var manuality: String?
    var clysally: [graphodomModel]?
    var cofilman: String?
    var octaneous: String?
    var military: militaryModel?
    var cladworry: [cladworryModel]?
    var emulable: String?
}

class oesophaglessModel: Codable {
    var side: Int?
    var cofilman: String?
    var octaneous: String?
    var termitmarketative: String?
    var economyical: String?
    var institutionance: String?
    var emeticad: String?
    var histriule: String?
    var themselveseur: String?
    var figmost: String?
}

class seishModel: Codable {
    var onomasify: String?
    var acutorium: String?
    var side: String?
    var cofilman: String?
    var octaneous: String?
    var cultural: String?
    var termitmarketative: String?
}

class totalsomeModel: Codable {
    var hetercarryar: String?
    var scal: String?
    var jug: Int?
    var medi: String?
    var tenacorium: String?
}

class terraeticModel: Codable {
    var thero: String?
}

class ludModel: Codable {
    var hetercarryar: String?
    var vetory: String?
    var lentfier: String?
    var blackence: String?
    var irasc: String?
    var pathyish: String?
    var coveresque: String?
    var graphodom: [graphodomModel]?
    
    private enum CodingKeys: String, CodingKey {
        case hetercarryar, vetory, lentfier, blackence, irasc, pathyish, coveresque, graphodom
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        hetercarryar = try container.decodeIfPresent(String.self, forKey: .hetercarryar)
        vetory = try container.decodeIfPresent(String.self, forKey: .vetory)
        lentfier = try container.decodeIfPresent(String.self, forKey: .lentfier)
        blackence = try container.decodeIfPresent(String.self, forKey: .blackence)
        irasc = try container.decodeIfPresent(String.self, forKey: .irasc)
        pathyish = try container.decodeIfPresent(String.self, forKey: .pathyish)
        graphodom = try container.decodeIfPresent([graphodomModel].self, forKey: .graphodom)
        
        if let stringValue = try? container.decode(String.self, forKey: .coveresque) {
            coveresque = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .coveresque) {
            coveresque = String(intValue)
        } else {
            coveresque = nil
        }
    }
}

class graphodomModel: Codable {
    var trueacle: String?
    var pathyish: String?
    
    private enum CodingKeys: String, CodingKey {
        case trueacle, pathyish
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intValue = try? container.decode(Int.self, forKey: .pathyish) {
            pathyish = String(intValue)
        } else {
            pathyish = try? container.decode(String.self, forKey: .pathyish)
        }
        
        trueacle = try? container.decode(String.self, forKey: .trueacle)
        
    }
}

class collegeModel: Codable {
    var actuallyify: [actuallyifyModel]?
}

class militaryModel: Codable {
    var mulsule: String?
}

class cladworryModel: Codable {
    var sitlike: String?
    var irasc: String?
}
