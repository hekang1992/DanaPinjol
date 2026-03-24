//
//  MineViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/17.
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
    
    func logoutInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await MineService.logoutInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func deleteInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await MineService.deleteInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    
}
