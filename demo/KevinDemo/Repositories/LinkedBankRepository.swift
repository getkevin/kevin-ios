//
//  LinkedBankRepository.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import Foundation
import RealmSwift
import Kevin

class LinkedBankRepository {
    
    private static let realm = try! Realm()

    static func findAll() -> Results<LinkedBank> {
        return realm.objects(LinkedBank.self)
    }
    
    static func delete(_ object: LinkedBank) {
        try? realm.write {
            realm.delete(object)
        }
    }

    static func saveLinkedBank(_ bank: ApiBank) {
        let linkedBank = LinkedBank()
        
        linkedBank.bankId = bank.id
        linkedBank.bankName = bank.name
        linkedBank.bankOfficialName = bank.officialName
        linkedBank.bankImageUrl = bank.imageUri
        linkedBank.bic = bank.bic
                
        try! realm.write {
            realm.add(linkedBank, update: .modified)
        }
    }
}
