//
//  PersonalViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import Combine
import Foundation

enum PersonalType: String {
    case list_Info = "1"
    case save_Info
}

class PersonalViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var action: PersonalType?
    
    func personalInfo(parameters: [String: Any]) {
        
        action = .list_Info
        
        Task {
            do {
                
                model = try await PersonalService.personalInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func savePersonalInfo(parameters: [String: Any]) {
        
        action = .save_Info
        
        Task {
            do {
                
                model = try await PersonalService.savePersonalInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
