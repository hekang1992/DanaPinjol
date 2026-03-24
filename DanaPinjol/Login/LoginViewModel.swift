//
//  LoginViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var action: LoginClickType?
    
    func codeInfo(parameters: [String: Any]) {
        
        Task {
            do {
                action = .code_info
                model = try await LoginService.codeInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func loginInfo(parameters: [String: Any]) {
        
        Task {
            do {
                action = .login_info
                model = try await LoginService.loginInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}


