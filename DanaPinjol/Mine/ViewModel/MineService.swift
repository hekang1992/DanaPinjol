//
//  MineService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
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
    
}
