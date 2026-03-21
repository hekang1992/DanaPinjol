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
    
    @Published var orderClickModel: BaseModel?
    
    func detailInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await ProductService.detailInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func orderNumClickInfo(parameters: [String: Any]) {
        
        Task {
            do {
                orderClickModel = try await ProductService.orderNumClickInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func uploadPointInfo(parameters: [String: String]) {
        
        Task {
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            do {
                model = try await ProductService.uploadPointInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
