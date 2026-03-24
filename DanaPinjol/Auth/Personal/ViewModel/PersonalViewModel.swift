//
//  PersonalViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/20.
//

import Combine
import Foundation

class PersonalViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var saveModel: BaseModel?
        
    func personalInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                model = try await PersonalService.personalInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func savePersonalInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                saveModel = try await PersonalService.savePersonalInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
