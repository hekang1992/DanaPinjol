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
    
    @Published var uploadmodel: BaseModel?
        
    func faceInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await FaceService.faceInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
    func uploadFaceInfo(parameters: [String: Any], imageData: Data) {
        
        Task {
            do {
                uploadmodel = try await FaceService.uploadFaceInfo(parameters: parameters,
                                                             imageData: imageData)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
