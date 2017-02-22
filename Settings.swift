//
//  Settings.swift
//  ProjectPretium
//
//  Created by Faannaka on 07.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import RealmSwift

class Settings: Object {
    dynamic var title: String = ""
    
    dynamic var bValue: Bool = false
    dynamic var dValue: Double = 0.0
    dynamic var sValue: String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

extension Settings {
    static func create(title: String, bValue: Bool, dValue: Double, sValue: String) -> Settings {
        return Settings(value: ["title": title, "bValue": bValue, "dValue": dValue, "sValue": sValue])
    }
}
