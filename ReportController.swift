//
//  ReportController.swift
//  ProjectPretium
//
//  Created by Faannaka on 12.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

enum Filters {
    case day
    case week
    case month
    case year
}

class ReportController: UITableViewController {
    
    var filterPredicate: NSPredicate!
    var transactionToken: NotificationToken!
    
    var currency: Currency!
    
    var categories: [Category]! {
        didSet {
            if categories.count > 0 {
                let dataEntries: [BarChartDataEntry] = self.categories.enumerated().map({ BarChartDataEntry.init(x: Double($0.offset), y: $0.element.transactions.filter(self.filterPredicate).sum(ofProperty: "localAmount"))})
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
                chartDataSet.colors = self.categories.map({ $0.color() })
                let chartData = BarChartData(dataSet: chartDataSet)
                barCharView.data = chartData
            } else {
                barCharView.data = nil
            }
            
            barCharView.animate(xAxisDuration: 0, yAxisDuration: 1)
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var barCharView: BarChartView! {
        didSet {
            barCharView.bounds.size.height = UIScreen.main.bounds.width / 1.2
            barCharView.highlightPerTapEnabled = false
            barCharView.legend.enabled = false
            barCharView.doubleTapToZoomEnabled = false
            barCharView.dragEnabled = false
            
            barCharView.xAxis.drawAxisLineEnabled = false
            barCharView.xAxis.drawGridLinesEnabled = false
            barCharView.xAxis.drawLabelsEnabled = false
            
            barCharView.chartDescription = nil
            barCharView.noDataFont = UIFont.systemFont(ofSize: 17)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = {
            let segment = UISegmentedControl(items: ["Day", "Week", "Month", "Year"])
            
            segment.selectedSegmentIndex = 0
            segment.addTarget(self, action: #selector(self.segmentSelectedItemChanged), for: .valueChanged)
            segment.bounds.size.width = UIScreen.main.bounds.width - 30
            
            return segment
        }()
        
        filterPredicate = filterPredicateFor(period: .day)
        
        let realm = try! Realm()
        
        transactionToken = realm.objects(Transaction.self).addNotificationBlock({ _ in
            self.getCategories()
        })
        currency = realm.objects(Currency.self).filter("main = true").first!
        
        getCategories()
    }
    
    func filterPredicateFor(period: Filters) -> NSPredicate {
        if period == Filters.day {
            let dayAgo = Int64(Calendar.current.date(byAdding: .day, value: -1, to: Date())!.timeIntervalSince1970.rounded())
            return NSPredicate(format: "id > \(dayAgo)")
        } else if period == Filters.week {
            let weekAgo = Int64(Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())!.timeIntervalSince1970.rounded())
            return NSPredicate(format: "id > \(weekAgo)")
        } else if period == Filters.month {
            let monthAgo = Int64(Calendar.current.date(byAdding: .month, value: -1, to: Date())!.timeIntervalSince1970.rounded())
            return NSPredicate(format: "id > \(monthAgo)")
        } else if period == Filters.year {
            let yearAgo = Int64(Calendar.current.date(byAdding: .year, value: -1, to: Date())!.timeIntervalSince1970.rounded())
            return NSPredicate(format: "id > \(yearAgo)")
        } else {
            return NSPredicate(format: "id = id")
        }
    }
    
    func getCategories() {
        let realm = try! Realm()
        
        categories = realm.objects(Category.self).filter({ (category) in
            let summary: Double = category.transactions.filter(filterPredicate).sum(ofProperty: "localAmount")
            
            return summary > 0
        })
    }
    
    func segmentSelectedItemChanged() {
        let segment = self.navigationItem.titleView as! UISegmentedControl
        
        if segment.selectedSegmentIndex == 0 {
            filterPredicate = filterPredicateFor(period: .day)
        } else if segment.selectedSegmentIndex == 1 {
            filterPredicate = filterPredicateFor(period: .week)
        } else if segment.selectedSegmentIndex == 2 {
            filterPredicate = filterPredicateFor(period: .month)
        } else if segment.selectedSegmentIndex == 3 {
            filterPredicate = filterPredicateFor(period: .year)
        }
        
        getCategories()
    }
    
    deinit {
        transactionToken?.stop()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportRow", for: indexPath) as! ReportCell
        
        cell.filterPredicate = filterPredicate
        cell.currency = currency
        cell.category = categories[indexPath.row]
        
        cell.selectedBackgroundView = {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = UIColor.clear
            return selectedBackgroundView
        }()
        
        return cell
    }

}
