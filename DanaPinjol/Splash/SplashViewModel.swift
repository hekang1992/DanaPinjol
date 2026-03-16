//
//  SplashViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Combine
import Foundation

class SplashViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func splashInfo(parameters: [String: Any]) {
        
        Task {
            do {
                
                model = try await SplashService.splashInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
