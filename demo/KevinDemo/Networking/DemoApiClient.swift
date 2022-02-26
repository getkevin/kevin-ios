//
//  DemoApiClient.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import PromiseKit

public class DemoApiClient: PSBaseApiClient {
    
    public func getCountryList() -> Promise<ApiCountries> {
        doRequest(requestRouter: DemoApiRequestRouter.getCountryList)
    }
    
    public func getCharityList(forCountryCode countryCode: String) -> Promise<ApiCharities> {
        doRequest(requestRouter: DemoApiRequestRouter.getCharityList(
            request: CharityListRequest(countryCode: countryCode)
        ))
    }

    public func initializeBankPayment(
        amount: String,
        email: String,
        iban: String,
        creditorName: String
    ) -> Promise<ApiPayment> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeBankPayment(
            request: InitiatePaymentRequest(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName
            )
        ))
    }
    
    public func initializeCardPayment(
        amount: String,
        email: String,
        iban: String,
        creditorName: String
    ) -> Promise<ApiPayment> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeCardPayment(
            request: InitiatePaymentRequest(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName
            )
        ))
    }
}
