//
//  Constants.swift
//  kevin.iOS
//
//
//  Created by Arthur Alehna on 17/10/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import UIKit

struct UserAgent {
    
    static var userAgentString: String {
        "KeviniOSSDK \(Constants.apiVersion)/\(deviceName())/\(deviceVersion())"
    }
    
    static private func deviceVersion() -> String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }

    static private func deviceName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
