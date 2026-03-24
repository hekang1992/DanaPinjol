//
//  NetworkMonitor.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/16.
//

import Foundation
import Alamofire

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let reachability = NetworkReachabilityManager()
    
    var statusBlock: ((NetworkReachabilityManager.NetworkReachabilityStatus) -> Void)?
    
    private init() {}
    
    func startListening(status: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        
        statusBlock = status
        
        reachability?.startListening(onUpdatePerforming: { [weak self] status in
            print("Network status: \(status)")
            self?.statusBlock?(status)
        })
        
    }
    
    func stopListening() {
        reachability?.stopListening()
        statusBlock = nil
    }
}

class NetworkUserDefaults {
    
    static let shared = NetworkUserDefaults()
    
    init() {}
    
     func saveNetwotkType(type: String) {
        UserDefaults.standard.set(type, forKey: "net_work_type")
        UserDefaults.standard.synchronize()
    }
    
     func getNetWorkType() -> String {
        return UserDefaults.standard.string(forKey: "net_work_type") ?? ""
    }
    
}
