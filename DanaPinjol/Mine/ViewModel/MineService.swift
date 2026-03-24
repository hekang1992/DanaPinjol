//
//  MineService.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
//

class MineService {
    
    static func mineInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/relatesion",
            parameters: parameters
        )
        
        return result
    }
    
    static func logoutInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/lentfier",
            parameters: parameters
        )
        
        return result
    }
    
    static func deleteInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/hetercarryar",
            parameters: parameters
        )
        
        return result
    }
    
}
