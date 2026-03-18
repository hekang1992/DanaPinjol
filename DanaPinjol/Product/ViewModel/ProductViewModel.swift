//
//  ProductViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Combine
import Foundation

class ProductViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func detailInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await ProductService.detailInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
