//
//  KevinBankError.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Foundation

enum KevinBankError: Error {
   case bankCredential
   case noLinkedBank
   case userInterruption
}
