//
//  S_DEVICE.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2023/01/12.
//

import UIKit

extension UIViewController {
    
    func DEVICE_RATIO() -> CGFloat {
        
        switch UIDevice.current.model {
        case "iPhone":
            if APPLE_DEVICE() == "Ratio 19.5:9" { return 60 } else if APPLE_DEVICE() == "Ratio 18:9" { return 44 } else { return 20 }
        default:
            print("\(UIDevice.current.model) 지원하지 않음"); return 20
        }
    }
    
    func GET_DEVICE_IDENTIFIER() -> String {
        
        var SYSTEM_INFO = utsname()
        uname(&SYSTEM_INFO)
        let MACHINE_MIRROR = Mirror(reflecting: SYSTEM_INFO.machine)
        let IDENTIFIER = MACHINE_MIRROR.children.reduce("") { identifier, element in
            guard let VALUE = element.value as? Int8, VALUE != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(VALUE)))
        }
        
        return IDENTIFIER
    }
    
    func APPLE_DEVICE() -> String {
        
        switch GET_DEVICE_IDENTIFIER() {
        
        //MARK: iPhone
        
        case "iPhone10,3", "iPhone10,6":                return "Ratio 18:9"         // iPhone X
        case "iPhone11,2":                              return "Ratio 18:9"         // iPhone XS
        case "iPhone11,4", "iPhone11,6":                return "Ratio 18:9"         // iPhone XS Max
        case "iPhone11,8":                              return "Ratio 18:9"         // iPhone XR
        case "iPhone12,1":                              return "Ratio 18:9"         // iPhone 11
        case "iPhone12,3":                              return "Ratio 18:9"         // iPhone 11 Pro
        case "iPhone12,5":                              return "Ratio 18:9"         // iPhone 11 Pro Max
        
        case "iPhone13,1":                              return "Ratio 18:9"         // iPhone 12 Mini
        case "iPhone13,2":                              return "Ratio 18:9"         // iPhone 12
        case "iPhone13,3":                              return "Ratio 18:9"         // iPhone 12 Pro
        case "iPhone13,4":                              return "Ratio 18:9"         // iPhone 12 Pro Max
            
        case "iPhone14,1":                              return "Ratio 18:9"         // iPhone 13 Mini
        case "iPhone14,5":                              return "Ratio 18:9"         // iPhone 13
        case "iPhone14,2":                              return "Ratio 18:9"         // iPhone 13 Pro
        case "iPhone14,3":                              return "Ratio 18:9"         // iPhone 13 Pro Max
            
        case "iPhone14,7":                              return "Ratio 18:9"         // iPhone 14
        case "iPhone14,8":                              return "Ratio 18:9"         // iPhone 14 Plus
        case "iPhone15,2":                              return "Ratio 19.5:9"       // iPhone 14 Pro
        case "iPhone15,3":                              return "Ratio 19.5:9"       // iPhone 14 Pro Max
            
        default: return "Ratio 16:9" }
    }
}
