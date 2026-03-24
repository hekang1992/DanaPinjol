//
//  FaceViewModel.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Foundation
import Combine

class FaceViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var uploadmodel: BaseModel?
    
    @Published var savemodel: BaseModel?
        
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
    
    func saveInfo(parameters: [String: Any]) {
        
        Task {
            do {
                savemodel = try await FaceService.saveInfo(parameters: parameters)
                
            } catch {
                
                errorMsg = error.localizedDescription
                
            }
        }
    }
    
}
