//
//  TransactionsController.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsController: UITableViewController {
    
    var account: Account! {
        didSet {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    lazy var transactions : Results<Transaction> = {
        let realm = try! Realm()
        
        if self.account == nil {
            return realm.objects(Transaction.self).sorted(byKeyPath: "id", ascending: false)
        } else {
            return realm.objects(Transaction.self).filter("account.title = '\(self.account!.title)'").sorted(byKeyPath: "id", ascending: false)
        }
    }()
    
    var transactionsToken: NotificationToken!
    
    lazy var currency: Settings! = {
        let realm = try! Realm()
        
        return realm.object(ofType: Settings.self, forPrimaryKey: "Currency")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transactionsToken = self.transactions.addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                self.tableView.endUpdates()
                break
            default:
                break
            }
        })
    }
    
    deinit {
        self.transactionsToken?.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! TransactionCell
        
        cell.transaction = transactions[indexPath.row]
        
        cell.selectedBackgroundView = {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            return selectedBackgroundView
        }()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = self.tableView.cellForRow(at: indexPath) as! TransactionCell
            
            let realm = try! Realm()
            
            try! realm.write {
                cell.transaction.account?.amount += cell.transaction.amount
                realm.delete(cell.transaction)
            }
        }
    }
    
    // MARK: Add new transaction
    
    func add(amount: Double, account: Account, category: Category, shopName: String, narrative: String, id: Int64? = nil) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTransaction" {
            if let controller = segue.destination as? AddTransactionController {
                controller.title = "Edit"
                
                if let cell = sender as? TransactionCell {
                    controller.transaction = cell.transaction
                }
            }
        }
    }
}
