//
//  MineViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import Foundation
import Combine

class MineViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func mineInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await MineService.mineInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    
}
