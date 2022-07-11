//
//  BankCredentialsPreferences.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import Foundation
import SwiftKeychainWrapper

class BankCredentialsPreferences {
        
    static func save(_ bankCredentials: BankCredentials) {
        guard let jsonData = try? JSONEncoder().encode(bankCredentials),
              let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
            return
        }

        KeychainWrapper.standard.set(jsonString, forKey: bankCredentials.bankId)
    }
    
    static func load(forBankId bankId: String) -> BankCredentials? {
        let jsonString = KeychainWrapper.standard.string(forKey: bankId)
        
        guard let dataFromJsonString = jsonString?.data(using: .utf8),
              let bankCredentials = try? JSONDecoder().decode(BankCredentials.self, from: dataFromJsonString) else {
            return nil
        }
        
        return bankCredentials
    }

    static func clear(forBankId bankId: String) {
        KeychainWrapper.standard.removeObject(forKey: bankId)
    }
}
