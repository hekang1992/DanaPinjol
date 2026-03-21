//
//  HomeService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import Foundation

class HomeService {
    
    static func homeInfo() async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/plurimon",
        )
        
        return result
    }
    
    static func homeClickInfo(parameters: [String: String]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        var requestJson = ["sportivity": String(Int(200 + 801)),
                           "borstarade": String(Int(100 + 900)),
                           "pausule": String(Int(1000))]
        
        requestJson.merge(parameters) { (current, new) in
            return new
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/canshe",
            parameters: requestJson
        )
        
        return result
    }
    
    static func uploadLocationInfo(parameters: [String: String]) async throws -> BaseModel? {
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/ownersive",
            parameters: parameters
        )
        
        return result
    }
    
    static func uploadMacInfo(parameters: [String: String]) async throws -> BaseModel? {
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/histriule",
            parameters: parameters
        )
        
        return result
    }
    
}
