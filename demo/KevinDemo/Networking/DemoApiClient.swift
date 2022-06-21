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

    public func initializeAccountLinking() -> Promise<ApiAuthState> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeAccountLinking(
            request: InitiateAccountLinkingRequest(scopes: ["payments", "accounts_basic"])
        ))
    }

    public func getAccessToken(authorizationCode: String) -> Promise<ApiAccessToken> {
        doRequest(requestRouter: DemoApiRequestRouter.getAccessToken(
            request: GetAccessTokenRequest(authorizationCode: authorizationCode)
        ))
    }

    public func refreshAccessToken(refreshToken: String) -> Promise<ApiAccessToken> {
        doRequest(requestRouter: DemoApiRequestRouter.refreshAccessToken(
            request: RefreshAccessTokenRequest(refreshToken: refreshToken)
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
    
    public func initializeLinkedBankPayment(
        amount: String,
        email: String,
        iban: String,
        creditorName: String,
        accessToken: String
    ) -> Promise<ApiPayment> {
        doRequest(requestRouter: DemoApiRequestRouter.initializeLinkedBankPayment(
            request: InitiatePaymentRequest(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName
            ),
            accessToken: accessToken
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
