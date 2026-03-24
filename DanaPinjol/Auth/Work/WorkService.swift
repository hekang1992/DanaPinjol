//
//  PersonalService.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/20.
//

class WorkService {
    
    static func workInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/coleous",
            parameters: parameters
        )
        
        return result
    }
    
    static func saveWorkInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/toxant",
            parameters: parameters
        )
        
        return result
    }
    
    
}
