//
//  SelectAccountController.swift
//  ProjectPretium
//
//  Created by Faannaka on 10.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class SelectAccountController: UITableViewController {
    
    var accounts: Results<Account> = {
        let realm = try! Realm()
        
        return realm.objects(Account.self)
    }()
    
    var accountCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath)

        cell.textLabel?.text = self.accounts[indexPath.row].title
        
        cell.selectedBackgroundView = {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            return selectedBackgroundView
        }()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = self.accounts[indexPath.row]
        
        self.accountCell.textLabel?.text = account.title
        self.accountCell.textLabel?.textColor = UIColor.black
        
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
