//
//  PersonalService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

class PoorService {
    
    static func bankInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/oesophagless",
            parameters: parameters
        )
        
        return result
    }
    
    static func saveBankInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/side",
            parameters: parameters
        )
        
        return result
    }
    
    
}
