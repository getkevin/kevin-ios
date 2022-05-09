//
//  KevinInAppPaymentsPlugin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinInAppPaymentsPlugin: KevinPlugin {
    
    public static let shared = KevinInAppPaymentsPlugin()
    
    private static let pluginKey = "kevinInAppPaymentsPlugin"
    private let accessQueue = DispatchQueue(label: "kevinInAppPaymentsPluginAccessQueue", attributes: .concurrent)
    
    private var configuration: KevinInAppPaymentsConfiguration? = nil
    
    private init() { }
    
    public func configure(_ configuration: KevinInAppPaymentsConfiguration) {
        accessQueue.async(flags: .barrier) {
            self.configuration = configuration
        }
    }
    
    public func getCallbackUrl() throws -> URL {
        guard let configuration = configuration else {
            throw KevinError(description: "KevinInAppPaymentsPlugin was not configured!")
        }
        return configuration.callbackUrl
    }
    
    public func processCallbackUrl(_ url: URL) {
        NotificationCenter.default.post(
            name: .onProcessCallback,
            object: url
        )
    }
    
    //MARK: KevinPlugin
    
    public func isConfigured() -> Bool {
        return configuration != nil
    }
    
    public func getKey() -> String {
        return KevinInAppPaymentsPlugin.pluginKey
    }
}
