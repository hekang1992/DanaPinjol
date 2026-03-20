//
//  ContactModel.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/20.
//

import UIKit
import Contacts
import ContactsUI

class ContactModel: Codable {
    var name: String
    var phones: String
    init(name: String, phones: String) {
        self.name = name
        self.phones = phones
    }
}

class ContactManager: NSObject {
    
    static let shared = ContactManager()
    private let store = CNContactStore()
    
    private var pickCompletion: ((ContactModel) -> Void)?
    
    func checkPermission(from vc: UIViewController, completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                    if !granted {
                        self.showSettingAlert(vc)
                    }
                }
            }
            
        case .authorized, .limited:
            completion(true)
            
        case .denied, .restricted:
            completion(false)
            showSettingAlert(vc)
            
        @unknown default:
            completion(false)
        }
    }
    
    func fetchAllContacts(from vc: UIViewController,
                          completion: @escaping ([ContactModel]) -> Void) {
        
        checkPermission(from: vc) { granted in
            guard granted else {
                completion([])
                return
            }
            
            DispatchQueue.global().async {
                var results: [ContactModel] = []
                
                let keys = [
                    CNContactGivenNameKey,
                    CNContactFamilyNameKey,
                    CNContactPhoneNumbersKey
                ] as [CNKeyDescriptor]
                
                let request = CNContactFetchRequest(keysToFetch: keys)
                
                do {
                    try self.store.enumerateContacts(with: request) { contact, _ in
                        
                        let name = contact.familyName + contact.givenName
                        
                        let phones = contact.phoneNumbers.map {
                            $0.value.stringValue
                        }.joined(separator: ",")
                        
                        if !phones.isEmpty {
                            let model = ContactModel(name: name, phones: phones)
                            results.append(model)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(results)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
        }
    }
    
    func pickContact(from vc: UIViewController,
                     completion: @escaping (ContactModel) -> Void) {
        
        self.pickCompletion = completion
        
        checkPermission(from: vc) { granted in
            guard granted else { return }
            
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            
            vc.present(picker, animated: true)
        }
    }
    
    // MARK: - 跳设置
    private func showSettingAlert(_ vc: UIViewController) {
        let alert = UIAlertController(
            title: "提示",
            message: "请在设置中开启通讯录权限",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        vc.present(alert, animated: true)
    }
}

extension ContactManager: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let name = contact.familyName + contact.givenName
        
        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
        
        let model = ContactModel(name: name, phones: phone)
        
        pickCompletion?(model)
    }
}
