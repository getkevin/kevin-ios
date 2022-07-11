//
//  BasePublishingUseCase.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Foundation
import Combine

open class BasePublishingUseCase<T> {
    
    public var subject: PassthroughSubject<T, Error>!
    public let apiClient = DemoApiClientFactory.createDemoApiClient(headers: RequestHeaders())

    public init() { }
    
    public func resetSubject() {
        self.subject = PassthroughSubject<T, Error>()
    }
}
