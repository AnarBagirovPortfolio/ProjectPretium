//
//  Account.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var currency: Currency?
    dynamic var amount: Double = 0.0
    
    let transactions = LinkingObjects(fromType: Transaction.self, property: "account")
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

extension Account {
    static func create(title: String, desc: String, currency: Currency, amount: Double) -> Account {
        return Account(value: ["title": title, "desc": desc, "currency": currency, "amount": amount])
    }
}
