//
//  AddTransactionController.swift
//  ProjectPretium
//
//  Created by Faannaka on 10.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class AddTransactionController: UITableViewController {
    
    @IBAction func editingChangedOn(_ sender: UITextField) {
        if account != nil {
            if sender == amountField && account.currency!.main {
                localAmountField.text = amountField.text
            }
        }
        
        enableSaveButton()
    }
    
    @IBOutlet weak var accountCell: UITableViewCell!
    @IBOutlet weak var categoryCell: UITableViewCell!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var localAmountField: UITextField!
    @IBOutlet weak var shopField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    var transaction: Transaction!
    
    var account: Account! {
        didSet {
            accountCell.textLabel?.text = account.title
            accountCell.detailTextLabel?.text = account.currency!.desc
            accountCell.textLabel?.textColor = UIColor.black
            
            if account.currency!.main {
                localAmountField.text = amountField.text
                localAmountField.isEnabled = false
            } else if !localAmountField.isEnabled {
                localAmountField.isEnabled = true
            }
            
            enableSaveButton()
        }
    }
    
    var category: Category! {
        didSet {
            categoryCell.textLabel?.text = category.title
            categoryCell.textLabel?.textColor = UIColor.black
            
            enableSaveButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = {
            return UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveButtonPressed))
        }()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if transaction != nil {
            account = transaction.account!
            category = transaction.category!
            amountField.text = AmountFormatter.string(from: transaction.amount)
            localAmountField.text = AmountFormatter.string(from: transaction.localAmount)
            shopField.text = transaction.shop
            descField.text = transaction.desc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveButtonPressed() {
        let amount: Double = NumberFormatter().number(from: amountField.text!)!.doubleValue
        let localAmount: Double = NumberFormatter().number(from: localAmountField.text!)!.doubleValue
        let shop: String = shopField.text ?? ""
        let desc: String = descField.text ?? ""
        
        let realm = try! Realm()
        
        try! realm.write {
            if transaction == nil {
                realm.add(Transaction.create(amount: amount, localAmount: localAmount, account: account, category: category, desc: desc, shop: shop))
                
                account.amount -= amount
            } else {
                if account == transaction!.account {
                    account.amount = account.amount + transaction!.amount - amount
                } else {
                    transaction!.account!.amount += transaction!.amount
                    account.amount -= amount
                    transaction!.account = account
                }
                
                if category != transaction!.category {
                    transaction!.category = category
                }
                
                transaction!.amount = amount
                transaction!.localAmount = localAmount
                transaction!.shop = shop
                transaction!.desc = desc
            }
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func enableSaveButton() {
        if account != nil {
            if category != nil {
                if let _ = NumberFormatter().number(from: amountField.text ?? "N/A") {
                    if let _ = NumberFormatter().number(from: localAmountField.text ?? "N/A") {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        return
                    }
                }
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectAccount" {
            if let accountCotroller = segue.destination as? AccountController {
                accountCotroller.previousController = self
            }
        } else if segue.identifier == "selectCategory" {
            if let categoryController = segue.destination as? CategoryController {
                categoryController.previousController = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
