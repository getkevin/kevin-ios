//
//  Result+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import Foundation
import RealmSwift

extension Results {
    
    public func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
