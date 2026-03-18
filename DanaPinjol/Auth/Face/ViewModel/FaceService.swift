//
//  FaceService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//



class FaceService {
    
    static func faceInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/seish",
            parameters: parameters
        )
        
        return result
    }
    
}
