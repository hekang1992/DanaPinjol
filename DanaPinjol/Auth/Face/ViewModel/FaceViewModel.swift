//
//  FaceViewModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Foundation
import Combine

class FaceViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func faceInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await FaceService.faceInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
