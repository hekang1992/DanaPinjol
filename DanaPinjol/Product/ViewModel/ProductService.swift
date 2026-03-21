//
//  ProductService.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Foundation

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
    
    static func orderNumClickInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/cofilman",
            parameters: parameters
        )
        
        return result
    }
    
    static func uploadPointInfo(parameters: [String: String]) async throws -> BaseModel? {
        
        let penwhilesive = IDFVHelper.getStoredIDFV()
        let saliid = IDFVHelper.getIDFA()
        let mechano = UserDefaults.standard.string(forKey: "dp_longitude") ?? ""
        let educationent = UserDefaults.standard.string(forKey: "dp_latitude") ?? ""
        
        var requestJson = ["penwhilesive": penwhilesive,
                           "saliid": saliid,
                           "mechano": mechano,
                           "educationent": educationent]
        
        requestJson.merge(parameters) { (current, new) in
            return new
        }
        
        let result: BaseModel = try await NetworkManager.shared.postRequest(
            url: "/prim/pausule",
            parameters: requestJson
        )
        
        return result
    }
    
}
