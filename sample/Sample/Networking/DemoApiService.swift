//
//  DemoApiService.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import Foundation
import Kevin

struct DemoApiService {

    let baseApiURL = "https://mobile-demo.kevin.eu/api/v1/"

    func fetchBankPaymentID(country: KevinCountry) async throws -> String? {
        guard let request = try await preparePaymentRequest(country: country) else {
            return nil
        }
        let initiatePaymentResponse = try await initiateBankPayment(request: request)
        return initiatePaymentResponse.id
    }

    func fetchCardPaymentID(country: KevinCountry) async throws -> String? {
        guard let request = try await preparePaymentRequest(country: country) else {
            return nil
        }
        let initiatePaymentResponse = try await initiateCardPayment(request: request)
        return initiatePaymentResponse.id
    }

    func fetchAuthState(request: AuthStateRequest) async throws -> AuthStateResponse  {
        let url = URL(string: baseApiURL + "auth/initiate?environment=SANDBOX&bankMode=TEST")!
        return try await makePostRequest(url: url, requestData: request)
    }

    private func initiateBankPayment(request: InitiatePaymentRequest) async throws -> InitiatePaymentResponse  {
        let url = URL(string: baseApiURL + "payments/bank?environment=SANDBOX&bankMode=TEST")!
        return try await makePostRequest(url: url, requestData: request)
    }

    private func initiateCardPayment(request: InitiatePaymentRequest) async throws -> InitiatePaymentResponse  {
        let url = URL(string: baseApiURL + "payments/card?environment=SANDBOX&bankMode=TEST")!
        return try await makePostRequest(url: url, requestData: request)
    }

    private func getCreditors(countryCode: String) async throws -> CreditorsResponse {
        var components = URLComponents(string: "https://api.getkevin.eu/demo/creditors")!
        components.queryItems = [URLQueryItem(name: "countryCode", value: countryCode)]
        return try await makeGetRequest(url: components.url!)
    }

    private func preparePaymentRequest(country: KevinCountry) async throws -> InitiatePaymentRequest? {
        let creditors = try await getCreditors(countryCode: country.rawValue)
        guard
            let creditor = creditors.data.first,
            let creditorAccount = creditor.accounts.first
        else {
            print("No creditors available for \(country)")
            return nil
        }

        return InitiatePaymentRequest(
            amount: "0.01",
            currencyCode: creditorAccount.currencyCode,
            email: "sample@sample.com",
            iban: creditorAccount.iban,
            creditorName: creditor.name,
            redirectUrl: try KevinInAppPaymentsPlugin.shared.getCallbackUrl().absoluteString
        )
    }

    private func makeGetRequest<R: Decodable>(url: URL) async throws -> R {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(R.self, from: data)
    }

    private func makePostRequest<T: Encodable, R: Decodable>(url: URL, requestData: T) async throws -> R {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONEncoder().encode(requestData)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(R.self, from: data)
    }
}
