//
//  CharacterSet+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 05/07/2022.
//

import Foundation

extension CharacterSet {
    public static var decimalDigitsWithSeparator: CharacterSet = .decimalDigits.union(CharacterSet (charactersIn: Locale.current.decimalSeparator ?? ""))
}
