//
//  SplashService.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

class SplashService {
    
    static func splashInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/arborization",
            parameters: parameters
        )
        
        return result
    }
    
}
