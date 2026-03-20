//
//  PersonalViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import Combine
import Foundation

class FineMeViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var saveModel: BaseModel?
    
    func contactInfo(parameters: [String: Any]) {
        
        Task {
            do {
                
                model = try await FineMeService.contactInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func saveContactInfo(parameters: [String: Any]) {
        
        Task {
            do {
                
                saveModel = try await FineMeService.saveContactInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func uploadContactInfo(parameters: [String: Any]) {
        
        Task {
            do {
                
                _ = try await FineMeService.uploadContactInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
