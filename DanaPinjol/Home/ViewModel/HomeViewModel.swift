//
//  HomeViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func homeInfo() {
        
        Task {
            do {
                model = try await HomeService.homeInfo()
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
