//
//  Transaction.swift
//  ProjectPretium
//
//  Created by Faannaka on 04.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    dynamic var id: Int64 = Int64(Date().timeIntervalSince1970.rounded())
    dynamic var amount: Double = 0.0
    dynamic var localAmount: Double = 0.0
    dynamic var account: Account?
    dynamic var category: Category?
    dynamic var desc: String = ""
    dynamic var shop: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Transaction {
    static func create(amount: Double, localAmount: Double, account: Account, category: Category, desc: String?, shop: String?) -> Transaction {
        let transaction = Transaction()
        
        transaction.amount = amount
        transaction.localAmount = localAmount
        transaction.account = account
        transaction.category = category
        transaction.desc = desc ?? ""
        transaction.shop = shop ?? ""
        
        return transaction
    }
    
    func formattedDate() -> String {
        let interval = TimeInterval(integerLiteral: Int64(self.id))
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = DateFormatter.Style.full
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
