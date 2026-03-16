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
}

class cylindModel: Codable {
    var probablyar: String?
    var discussship: discussshipModel?
}

class discussshipModel: Codable {
    var myee: String?
    var trialition: String?
    var naturalably: String?
    var toughture: String?
}
