//
//  LinkedBank.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import Foundation
import RealmSwift

public class LinkedBank: Object {
    
    @Persisted public var bankId: String
    @Persisted public var bankName: String
    @Persisted public var bankOfficialName: String?
    @Persisted public var bankImageUrl: String
    @Persisted public var bic: String?

    public override class func primaryKey() -> String? {
        return "bankId"
    }
}
