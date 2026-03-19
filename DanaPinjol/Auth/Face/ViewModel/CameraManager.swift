//
//  CameraManager.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/18.
//

import UIKit
import AVFoundation

class CameraManager: NSObject {
    
    var completionHandler: ((Data?) -> Void)?
    
    private var imagePicker: UIImagePickerController?
    
    private weak var presentingViewController: UIViewController?
    
    private var currentCameraDevice: UIImagePickerController.CameraDevice = .rear
    
    static let shared = CameraManager()
    
    private override init() {
        super.init()
    }
    
    func showCamera(from viewController: UIViewController, completion: @escaping (Data?) -> Void) {
        self.presentingViewController = viewController
        self.completionHandler = completion
        
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                DispatchQueue.main.async {
                    self.presentCamera()
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermissionAlert()
                    self.completionHandler?(nil)
                }
            }
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completionHandler?(nil)
            return
        }
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .camera
        imagePicker?.allowsEditing = false
        imagePicker?.cameraDevice = currentCameraDevice
        imagePicker?.showsCameraControls = true
        
        if let imagePicker = imagePicker {
            presentingViewController?.present(imagePicker, animated: true)
        }
    }
    
    @objc private func switchCameraTapped() {
        guard let imagePicker = imagePicker else { return }
        
        if imagePicker.cameraDevice == .rear {
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imagePicker.cameraDevice = .front
                currentCameraDevice = .front
            }
        } else {
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imagePicker.cameraDevice = .rear
                currentCameraDevice = .rear
            }
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "需要相机权限",
            message: "请在iPhone的\"设置-隐私-相机\"中允许应用访问相机",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "去设置", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        presentingViewController?.present(alert, animated: true)
    }
    
    private func compressImageToData(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        let maxSizeBytes = maxSizeKB * 1024
        
        var compression: CGFloat = 0.8
        guard let imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        if imageData.count <= maxSizeBytes {
            return imageData
        }
        
        var lowerBound: CGFloat = 0.0
        var upperBound: CGFloat = compression
        var bestImageData = imageData
        
        for _ in 0..<10 {
            compression = (lowerBound + upperBound) / 2
            if let compressedData = image.jpegData(compressionQuality: compression) {
                if compressedData.count <= maxSizeBytes {
                    bestImageData = compressedData
                    lowerBound = compression
                } else {
                    upperBound = compression
                }
            } else {
                upperBound = compression
            }
        }
        
        return bestImageData
    }
    
    private func compressWithSizeReduction(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        
        if let compressedData = compressImageToData(image, maxSizeKB: maxSizeKB) {
            return compressedData
        }
        
        var scale: CGFloat = 0.9
        var currentImage = image
        
        while scale > 0.3 {
            let newSize = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            currentImage.draw(in: CGRect(origin: .zero, size: newSize))
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                
                if let compressedData = compressImageToData(resizedImage, maxSizeKB: maxSizeKB) {
                    return compressedData
                }
                
                currentImage = resizedImage
            } else {
                UIGraphicsEndImageContext()
            }
            
            scale -= 0.1
        }
        
        return nil
    }
    
    func toggleCamera() {
        if currentCameraDevice == .rear {
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                currentCameraDevice = .front
                imagePicker?.cameraDevice = .front
            }
        } else {
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                currentCameraDevice = .rear
                imagePicker?.cameraDevice = .rear
            }
        }
    }
}

extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            var selectedImage: UIImage?
            
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
            }
            
            if let image = selectedImage {
                let compressedData = self.compressWithSizeReduction(image, maxSizeKB: 500)
                self.completionHandler?(compressedData)
            } else {
                self.completionHandler?(nil)
            }
            
            self.imagePicker = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.completionHandler?(nil)
            self?.imagePicker = nil
        }
    }
}
