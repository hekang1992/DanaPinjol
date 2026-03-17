//
//  HomeService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

class HomeService {
    
    static func homeInfo() async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.getRequest(
            url: "/prim/plurimon",
        )
        
        return result
    }
    
}
