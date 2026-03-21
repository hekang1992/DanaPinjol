//
//  HomeViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import Combine
import Foundation

enum HomeClickType: String {
    case home_info = "1"
    case click_info
}

class HomeViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var action: HomeClickType?
    
    func homeInfo() {
        
        Task {
            do {
                action = .home_info
                model = try await HomeService.homeInfo()
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func homeClickInfo(parameters: [String: String]) {
        
        Task {
            do {
                action = .click_info
                model = try await HomeService.homeClickInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func uploadLocationInfo(parameters: [String: String]) {
        
        Task {
            do {
                _ = try await HomeService.uploadLocationInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func uploadMacInfo(parameters: [String: String]) {
        
        Task {
            do {
                _ = try await HomeService.uploadMacInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
