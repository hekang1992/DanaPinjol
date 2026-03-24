//
//  OrderViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/20.
//

import Combine
import Foundation

class OrderViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
        
    func orderListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                
                model = try await OrderService.orderListInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
