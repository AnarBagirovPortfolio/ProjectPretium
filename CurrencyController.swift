//
//  CurrencyController.swift
//  ProjectPretium
//
//  Created by Faannaka on 06.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class CurrencyController: UITableViewController {
    
    var previousController: UIViewController!
    
    lazy var currencies : Results<Currency>! = {
        let realm = try! Realm()
        
        return realm.objects(Currency.self).sorted(byKeyPath: "title")
    }()

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
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath)

        cell.textLabel?.text = currencies[indexPath.row].title
        cell.detailTextLabel?.text = currencies[indexPath.row].desc
        
        if currencies[indexPath.row].main {
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 1, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
            cell.detailTextLabel?.textColor = UIColor(colorLiteralRed: 1, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
        }
        
        cell.selectedBackgroundView = {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            return selectedBackgroundView
        }()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = self.previousController as? AddAccountController {
            controller.currency = self.currencies[indexPath.row]
            
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
