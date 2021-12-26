//
//  DemoApiClient.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import PromiseKit

public class DemoApiClient: PSBaseApiClient {
    
    public func getAuthState() -> Promise<ApiAuthState> {
        doRequest(requestRouter: DemoApiRequestRouter.getAuthState(
            request: GetAuthStateRequest(scopes: ["payments"]))
        )
    }
    
    public func initializeBankPayment() -> Promise<ApiPayment> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeBankPayment(
            request: InitiatePaymentRequest(amount: "0.01")
        ))
    }
    
    public func initializeCardPayment() -> Promise<ApiPayment> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeCardPayment(
            request: InitiatePaymentRequest(amount: "0.01")
        ))
    }
}
