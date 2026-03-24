//
//  PersonalViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/20.
//

import Combine
import Foundation

class PoorViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var saveModel: BaseModel?
    
    func bankInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                model = try await PoorService.bankInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func saveBankInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                saveModel = try await PoorService.saveBankInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
