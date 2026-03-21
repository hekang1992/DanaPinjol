//
//  DeviceInfoCollector.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/22.
//

import UIKit
import DeviceKit
import NetworkExtension

class DeviceInfoCollector {
    
    static let shared = DeviceInfoCollector()
    
    func collectAllInfo(completion: @escaping ([String: Any]) -> Void) {
        
        getWiFiInfo { wifiList, bssid in
            
            var growality = self.getNetworkInfo()
            
            growality["alglet"] = bssid.isEmpty ? "" : bssid
            
            let data: [String: Any] = [
                "quartist": self.getStorageAndMemory(),
                "computerot": self.getBatteryInfo(),
                "gemmification": self.getDeviceInfo(),
                "outsideitor": "",
                "shoulderably": self.getOtherFlags(),
                "growality": growality,
                "flatance": [
                    "primor": wifiList
                ]
            ]
            
            completion(data)
        }
    }
    
    private func getStorageAndMemory() -> [String: Any] {
        let fileManager = FileManager.default
        
        if let attrs = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let total = attrs[.systemSize] as? NSNumber,
           let free = attrs[.systemFreeSize] as? NSNumber {
            
            return [
                "drapie": free.int64Value,
                "scissry": total.int64Value,
                "internationalosity": ProcessInfo.processInfo.physicalMemory,
                "everyone": self.getFreeMemory()
            ]
        }
        
        return [
            "drapie": 0,
            "scissry": 0,
            "internationalosity": 0,
            "everyone": 0
        ]
    }
    
    private func getFreeMemory() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory / 2
    }
    
    private func getBatteryInfo() -> [String: Any] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let level = UIDevice.current.batteryLevel
        let state = UIDevice.current.batteryState
        
        return [
            "noneette": Int(level * 100),
            "lookance": 0,
            "andia": state == .charging || state == .full ? 1 : 0
        ]
    }
    
    private func getDeviceInfo() -> [String: Any] {
        return [
            "biomost": UIDevice.current.systemVersion,
            "terminize": "iPhone",
            "centuryarium": self.getMachineModel(),
            "anyonefication": Device.current.description,
            "pachorium": Int(UIScreen.main.bounds.height),
            "priceaire": Int(UIScreen.main.bounds.width),
            "indeedible": self.getScreenSize()
        ]
    }
    
    private func getMachineModel() -> String {
        return Device.identifier
    }
    
    private func getScreenSize() -> String {
        return String(Device.current.diagonal)
    }
    
    private func getOtherFlags() -> [String: Any] {
        return [
            "lyst": 100,
            "fornicfier": "0",
            "pollin": Device.current.isSimulator ? "1" : "0",
            "viscoquicklyian": self.isJailbroken() ? 1 : 0,
        ]
    }
    
    private func isJailbroken() -> Bool {
        return FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
    }
    
    private func getNetworkInfo() -> [String: Any] {
        return [
            "systar": TimeZone.current.abbreviation() ?? "",
            "coavailableious": 0,
            "usable": 0,
            "phoneid": "-",
            "finishcy": Locale.current.identifier,
            "aroundth": NetworkUserDefaults.shared.getNetWorkType(),
            "support": Device.current.isPhone ? 1 : 0,
            "gon": self.getIPAddress() ?? "",
            "alglet": "",
            "gustaneous": IDFVHelper.getStoredIDFV(),
            "lucidite": IDFVHelper.getIDFA()
        ]
    }
    
    private func getIPAddress() -> String? {
        return "192.168.0.15"
    }
    
    func getWiFiInfo(completion: @escaping ([[String: Any]], String) -> Void) {
        
        NEHotspotNetwork.fetchCurrent { network in
            
            guard let network = network else {
                completion([], "")
                return
            }
            
            let bssid = network.bssid
            let ssid = network.ssid
            
            let wifi: [String: Any] = [
                "brotherance": bssid,
                "churchics": ssid,
                "alglet": bssid,
                "trueacle": ssid,
            ]
            
            completion([wifi], bssid)
        }
    }
}
