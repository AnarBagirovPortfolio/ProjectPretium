//
//  Category.swift
//  ProjectPretium
//
//  Created by Faannaka on 07.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Category: Object {
    dynamic var title: String = ""
    let transactions = LinkingObjects(fromType: Transaction.self, property: "category")
    
    dynamic var red: Double = 0.0
    dynamic var green: Double = 0.0
    dynamic var blue: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

extension Category {
    static func create(title: String, _ red: Double, _ blue: Double, _ green: Double) -> Category {
        return Category(value: ["title": title, "red": red, "green": green, "blue": blue])
    }
    
    func color() -> UIColor {
        let red = CGFloat(self.red / 255.0)
        let green = CGFloat(self.green / 255.0)
        let blue = CGFloat(self.blue / 255.0)
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func image() -> UIImage {
        switch self.title {
        case "Business":
            return #imageLiteral(resourceName: "Business")
        case "Cinema":
            return #imageLiteral(resourceName: "Cinema")
        case "Clothes":
            return #imageLiteral(resourceName: "Clothes")
        case "Debt":
            return #imageLiteral(resourceName: "Debt")
        case "Education":
            return #imageLiteral(resourceName: "Education")
        case "Entertainment":
            return #imageLiteral(resourceName: "Entertaiment")
        case "Family":
            return #imageLiteral(resourceName: "Family")
        case "Food and drinks":
            return #imageLiteral(resourceName: "Food and Drinks")
        case "Gift":
            return #imageLiteral(resourceName: "Gift")
        case "Healthcare":
            return #imageLiteral(resourceName: "Healthcare")
        case "Hobbies":
            return #imageLiteral(resourceName: "Hobbies")
        case "House":
            return #imageLiteral(resourceName: "House")
        case "Job":
            return #imageLiteral(resourceName: "Job")
        case "Other":
            return #imageLiteral(resourceName: "Other")
        case "Pets":
            return #imageLiteral(resourceName: "Pets")
        case "Savings":
            return #imageLiteral(resourceName: "Savings")
        case "Transport":
            return #imageLiteral(resourceName: "Transport")
        case "Travel":
            return #imageLiteral(resourceName: "Travel")
        case "Utilities":
            return #imageLiteral(resourceName: "Utilities")
        default:
            return #imageLiteral(resourceName: "Other")
        }
    }
}
