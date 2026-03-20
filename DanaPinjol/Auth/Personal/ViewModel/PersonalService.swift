//
//  PersonalService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

class PersonalService {
    
    static func personalInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/opportunity",
            parameters: parameters
        )
        
        return result
    }
    
    static func savePersonalInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/anthroposeaatory",
            parameters: parameters
        )
        
        return result
    }
    
    
}
