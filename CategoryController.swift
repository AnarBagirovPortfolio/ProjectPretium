//
//  CategoryController.swift
//  ProjectPretium
//
//  Created by Faannaka on 07.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>!
    
    var previousController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categories = realm.objects(Category.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryCell

        cell.category = self.categories[indexPath.row]
        
        cell.selectedBackgroundView = {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            return selectedBackgroundView
        }()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addTransactionController = previousController as? AddTransactionController {
            addTransactionController.category = categories[indexPath.row]
            
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
