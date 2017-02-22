//
//  Currency.swift
//  ProjectPretium
//
//  Created by Faannaka on 06.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import RealmSwift

class Currency: Object {
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var main: Bool = false
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

extension Currency {
    static func create(title: String, desc: String) -> Currency {
        let currency = Currency()
        
        currency.title = title
        currency.desc = desc
        
        return currency
    }
}
