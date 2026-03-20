//
//  PersonalService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

class FineMeService {
    
    static func contactInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/actuallyify",
            parameters: parameters
        )
        
        return result
    }
    
    static func saveContactInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/pathyish",
            parameters: parameters
        )
        
        return result
    }
    
    static func uploadContactInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/figmost",
            parameters: parameters
        )
        
        return result
    }
    
    
}
