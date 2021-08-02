//
//  DemoApiClientFactory.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Alamofire

public class DemoApiClientFactory {
    
    public static func createDemoApiClient(
        headers: RequestHeaders,
        credentials: JWTCredentials? = nil,
        tokenRefresher: TokenRefresherProtocol? = nil,
        logger: LoggerProtocol? = nil
    ) -> DemoApiClient {
        let interceptor = BaseApiRequestAdapter(credentials: credentials, headers: headers)
        let session = Session(interceptor: interceptor)
        
        return DemoApiClient(
            session: session,
            credentials: credentials,
            tokenRefresher: tokenRefresher,
            logger: logger
        )
    }
}
