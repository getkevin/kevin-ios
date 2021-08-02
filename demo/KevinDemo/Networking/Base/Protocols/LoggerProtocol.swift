//
//  LoggerProtocol.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public enum LoggerLevel {
    case DEBUG, INFO, ERROR
}

public protocol LoggerProtocol {
    func log(level: LoggerLevel, message: String)
    func log(level: LoggerLevel, message: String, request: URLRequest)
    func log(level: LoggerLevel, message: String, response: HTTPURLResponse)
    func log(level: LoggerLevel, message: String, response: HTTPURLResponse, error: ApiError)
}
