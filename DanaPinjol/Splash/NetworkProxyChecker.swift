//
//  NetworkProxyChecker.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import Foundation
import SystemConfiguration

class NetworkProxyChecker {
    
    static func getProxyStatus() -> String {
        return isUsingProxy() ? "1" : "0"
    }
    
    static func getVPNStatus() -> String {
        return isUsingVPN() ? "1" : "0"
    }
    
    private static func isUsingProxy() -> Bool {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else {
            return false
        }
        
        guard let settings = proxySettings as? [String: Any] else {
            return false
        }
        
        if let httpEnable = settings["HTTPEnable"] as? Int, httpEnable == 1 {
            return true
        }
        
        if let httpsEnable = settings["HTTPSEnable"] as? Int, httpsEnable == 1 {
            return true
        }
        
        if let socksEnable = settings["SOCKSEnable"] as? Int, socksEnable == 1 {
            return true
        }
        
        if let httpProxy = settings["HTTPProxy"] as? String, !httpProxy.isEmpty {
            return true
        }
        
        if let httpsProxy = settings["HTTPSProxy"] as? String, !httpsProxy.isEmpty {
            return true
        }
        
        return false
    }
    
    private static func isUsingVPN() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else {
            return false
        }
        
        guard let dict = cfDict as? [String: Any] else {
            return false
        }
        
        guard let scoped = dict["__SCOPED__"] as? [String: Any] else {
            return false
        }
        
        let vpnInterfacePrefixes = ["tap", "tun", "ppp", "ipsec", "utun", "vpn", "ipsec", "ike"]
        
        for key in scoped.keys {
            for prefix in vpnInterfacePrefixes {
                if key.lowercased().hasPrefix(prefix) {
                    return true
                }
            }
            
            let lowercasedKey = key.lowercased()
            if lowercasedKey.contains("vpn") ||
                lowercasedKey.contains("tunnel") ||
                lowercasedKey.contains("ppp") ||
                lowercasedKey.contains("ipsec") {
                return true
            }
        }
        
        return false
    }
}
