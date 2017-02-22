//
//  SetMainCurrencyController.swift
//  ProjectPretium
//
//  Created by Faannaka on 19.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import RealmSwift

class SetMainCurrencyController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var currencies : Results<Currency>! = {
        let realm = try! Realm()
        
        return realm.objects(Currency.self).sorted(byKeyPath: "title")
    }()

    @IBOutlet weak var currenciesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currenciesTableView.delegate = self
        self.currenciesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath)
        
        cell.textLabel?.text = currencies[indexPath.row].title
        cell.detailTextLabel?.text = currencies[indexPath.row].desc
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        
        try! realm.write {
            for currency in currencies {
                if currency.main {
                    currency.main = false
                }
            }
            currencies[indexPath.row].main = true
            
            realm.add(Account.create(title: "Main account", desc: "This is main account", currency: currencies[indexPath.row], amount: 500))
        }
        
        self.currenciesTableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainTabBar = storyBoard.instantiateViewController(withIdentifier: "MainTabBar")
        self.present(mainTabBar, animated:true, completion:nil)
    }
    
}
