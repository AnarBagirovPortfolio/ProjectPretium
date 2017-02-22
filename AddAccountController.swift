//
//  AddAccountController.swift
//  ProjectPretium
//
//  Created by Faannaka on 17.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class AddAccountController: UITableViewController {
    
    var account: Account!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    @IBOutlet weak var transactionsCell: UITableViewCell!
    @IBOutlet weak var currencyCell: UITableViewCell!
    
    @IBAction func editingChangedOn(_ sender: UITextField) {
        self.enableSaveButton()
    }
    
    var currency: Currency! {
        didSet {
            currencyCell.textLabel?.text = self.currency.title
            currencyCell.detailTextLabel?.text = self.currency.desc
            currencyCell.textLabel?.textColor = UIColor.black
            
            self.enableSaveButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = {
            return UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveButtonPressed))
        }()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if account != nil {
            self.navigationItem.title = "Edit"
            
            transactionsCell.isHidden = false
            currency = account.currency!
            titleField.text = account.title
            descField.text = account.desc
            balanceField.text = AmountFormatter.string(from: account.amount)
            
            titleField.isEnabled = false
            currencyCell.isUserInteractionEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveButtonPressed() {
        if let amount = NumberFormatter().number(from: balanceField.text ?? "N/A")?.doubleValue {
            let title = titleField.text ?? ""
            let desc = descField.text ?? ""
            
            let realm = try! Realm()
            
            if realm.object(ofType: Account.self, forPrimaryKey: title) == nil && !title.isEmpty {
                try! realm.write {
                    realm.add(Account.create(title: title, desc: desc, currency: currency, amount: amount))
                }
            } else {
                if account != nil {
                    try! realm.write {
                        account.amount = amount
                        account.desc = desc
                        account.currency = currency
                    }
                }
            }
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCurrency" {
            if let nextController = segue.destination as? CurrencyController {
                nextController.previousController = self
            }
        } else if segue.identifier == "accountTransactions" {
            if let controller = segue.destination as? TransactionsController {
                controller.account = account
            }
        }
    }
    
    func enableSaveButton() {
        if self.currency != nil {
            if let _ = NumberFormatter().number(from: balanceField.text ?? "N/A") {
                if !(titleField.text ?? "").isEmpty {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
