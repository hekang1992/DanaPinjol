//
//  LoginService.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

class LoginService {
    
    static func codeInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/futuretion",
            parameters: parameters
        )
        
        return result
    }
    
    static func loginInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/siccing",
            parameters: parameters
        )
        
        return result
    }
    
}
