//
//  PersonalService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

class OrderService {
    
    static func orderListInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/octaneous",
            parameters: parameters
        )
        
        return result
    }
    
}
