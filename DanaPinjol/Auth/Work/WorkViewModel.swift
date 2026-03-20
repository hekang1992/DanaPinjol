//
//  PersonalViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import Combine
import Foundation

class WorkViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var saveModel: BaseModel?
    
    func workInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                model = try await WorkService.workInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func saveWorkInfo(parameters: [String: Any]) {
                
        Task {
            do {
                
                saveModel = try await WorkService.saveWorkInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
