//
//  KevinAccountsPlugin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinAccountsPlugin: KevinPlugin {
    
    public static let shared = KevinAccountsPlugin()
    
    private static let pluginKey = "kevinAccountsPlugin"
    private let accessQueue = DispatchQueue(label: "kevinAccountsPluginAccessQueue", attributes: .concurrent)
    
    private var configuration: KevinAccountsConfiguration? = nil
    
    private init() { }
    
    public func configure(_ configuration: KevinAccountsConfiguration) {
        accessQueue.async(flags: .barrier) {
            self.configuration = configuration
        }
    }
    
    public func getCallbackUrl() throws -> URL {
        guard let configuration = configuration else {
            throw KevinError(description: "KevinAccountsPlugin was not configured!")
        }
        return configuration.callbackUrl
    }
    
    //MARK: KevinPlugin
    
    public func isConfigured() -> Bool {
        return configuration != nil
    }
    
    public func getKey() -> String {
        return KevinAccountsPlugin.pluginKey
    }
}
