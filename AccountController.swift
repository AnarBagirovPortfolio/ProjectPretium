//
//  AccountController.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class AccountController: UITableViewController {
    
    var previousController: UIViewController! {
        didSet {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    lazy var accounts: Results<Account> = {
        let realm = try! Realm()
        
        return realm.objects(Account.self)
    }()
    
    var accountsToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accountsToken = self.accounts.addNotificationBlock({ (changes: RealmCollectionChange) in
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
        self.accountsToken?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath) as! AccountCell

        cell.account = self.accounts[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            
            let cell = self.tableView.cellForRow(at: indexPath) as! AccountCell
            let transactions = realm.objects(Transaction.self).filter("account.title = '\(cell.account!.title)'")
            
            try! realm.write {
                realm.delete(transactions)
                realm.delete(cell.account)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addTRansactionController = previousController as? AddTransactionController {
            addTRansactionController.account = accounts[indexPath.row]
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAccount" {
            if let controller = segue.destination as? AddAccountController {
                if let accountCell = sender as? AccountCell {
                    controller.account = accountCell.account
                    
                }
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return previousController == nil
    }
}
