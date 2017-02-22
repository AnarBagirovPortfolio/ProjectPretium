//
//  Extensions.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func clear() {
        if let textFields = self.textFields {
            for textField in textFields {
                textField.text = nil
            }
        }
        
        for action in self.actions {
            action.isEnabled = false
        }
    }
}

func showError(view: UIViewController, message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    view.present(alert, animated: true, completion: nil)
}

class AmountFormatter {
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale.current
        f.numberStyle = .currency
        
        return f
    }()
    
    private init() {
        
    }
    
    static func string(from amount: Double, currency: String) -> String? {
        AmountFormatter.formatter.currencySymbol = currency
        return AmountFormatter.formatter.string(from: NSNumber(value: amount))?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func string(from amount: Double) -> String? {
        AmountFormatter.formatter.currencySymbol = ""
        return AmountFormatter.formatter.string(from: NSNumber(value: amount))?.components(separatedBy: .whitespaces).joined()
    }
}

