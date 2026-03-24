//
//  DeviceInfoCollector.swift
//  DanaPinjol
//
//  Created by Ethan Parker on 2026/3/22.
//

import UIKit
import DeviceKit
import NetworkExtension
import MachO
import Darwin

final class DeviceInfoCollector {
    
    static let shared = DeviceInfoCollector()
    private init() {}
    
    func collectAllInfo(completion: @escaping ([String: Any]) -> Void) {
        
        getWiFiInfo { wifiList, bssid in
            
            var networkInfo = self.getNetworkInfo()
            networkInfo["alglet"] = bssid.isEmpty ? "" : bssid
            
            let result: [String: Any] = [
                "quartist": self.getStorageAndMemory(),
                "computerot": self.getBatteryInfo(),
                "gemmification": self.getDeviceInfo(),
                "shoulderably": self.getOtherFlags(),
                "growality": networkInfo,
                "flatance": [
                    "primor": wifiList
                ]
            ]
            
            completion(result)
        }
    }
}

// MARK: - Storage & Memory
private extension DeviceInfoCollector {
    
    func getStorageAndMemory() -> [String: Any] {
        
        guard
            let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
            let total = attrs[.systemSize] as? NSNumber,
            let free = attrs[.systemFreeSize] as? NSNumber
        else {
            return emptyStorage()
        }
        
        return [
            "drapie": free.int64Value,
            "scissry": total.int64Value,
            "internationalosity": ProcessInfo.processInfo.physicalMemory,
            "everyone": getFreeMemory()
        ]
    }
    
    func emptyStorage() -> [String: Any] {
        return [
            "drapie": 0,
            "scissry": 0,
            "internationalosity": 0,
            "everyone": 0
        ]
    }
    
    func getFreeMemory() -> UInt64 {
        
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(
            MemoryLayout<vm_statistics64_data_t>.size /
            MemoryLayout<integer_t>.size
        )
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else { return 0 }
        
        let pageSize = vm_kernel_page_size
        
        let free = UInt64(stats.free_count) * UInt64(pageSize)
        let inactive = UInt64(stats.inactive_count) * UInt64(pageSize)
        
        return free + inactive
    }
}

private extension DeviceInfoCollector {
    
    func getBatteryInfo() -> [String: Any] {
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let level = UIDevice.current.batteryLevel
        let state = UIDevice.current.batteryState
        
        return [
            "noneette": Int(level * 100),
            "lookance": 0,
            "andia": (state == .charging || state == .full) ? 1 : 0
        ]
    }
}

private extension DeviceInfoCollector {
    
    func getDeviceInfo() -> [String: Any] {
        return [
            "biomost": UIDevice.current.systemVersion,
            "terminize": "iPhone",
            "centuryarium": getMachineModel(),
            "anyonefication": Device.current.description,
            "pachorium": Int(UIScreen.main.bounds.height),
            "priceaire": Int(UIScreen.main.bounds.width),
            "indeedible": getScreenSize()
        ]
    }
    
    func getMachineModel() -> String {
        Device.identifier
    }
    
    func getScreenSize() -> String {
        String(Device.current.diagonal)
    }
}

private extension DeviceInfoCollector {
    
    func getOtherFlags() -> [String: Any] {
        return [
            "lyst": 100,
            "fornicfier": "0",
            "pollin": Device.current.isSimulator ? "1" : "0",
            "viscoquicklyian": isJailbroken() ? 1 : 0
        ]
    }
    
    func isJailbroken() -> Bool {
        FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
    }
}

private extension DeviceInfoCollector {
    
    func getNetworkInfo() -> [String: Any] {
        return [
            "systar": TimeZone.current.abbreviation() ?? "",
            "coavailableious": NetworkProxyChecker.getProxyStatus(),
            "usable": NetworkProxyChecker.getVPNStatus(),
            "phoneid": "-",
            "finishcy": Locale.current.identifier,
            "aroundth": NetworkUserDefaults.shared.getNetWorkType(),
            "support": Device.current.isPhone ? 1 : 0,
            "gon": getIPAddress() ?? "",
            "alglet": "",
            "gustaneous": IDFVHelper.getStoredIDFV(),
            "lucidite": IDFVHelper.getIDFA()
        ]
    }
}

private extension DeviceInfoCollector {
    
    func getIPAddress() -> String? {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        
        var ptr = ifaddr
        
        while ptr != nil {
            
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee else { continue }
            
            let family = interface.ifa_addr.pointee.sa_family
            
            if family == UInt8(AF_INET) {
                
                let name = String(cString: interface.ifa_name)
                
                guard name == "en0" || name == "pdp_ip0" else { continue }
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                getnameinfo(
                    interface.ifa_addr,
                    socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname,
                    socklen_t(hostname.count),
                    nil,
                    0,
                    NI_NUMERICHOST
                )
                
                let ip = String(cString: hostname)
                
                if ip != "0.0.0.0" {
                    address = ip
                    break
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}

extension DeviceInfoCollector {
    
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
                "trueacle": ssid
            ]
            
            completion([wifi], bssid)
        }
    }
}
