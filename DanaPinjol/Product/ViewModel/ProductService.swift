//
//  ProductService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

class ProductService {
    
    static func detailInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/againoon",
            parameters: parameters
        )
        
        return result
    }
    
}
