//
//  ReportCell.swift
//  ProjectPretium
//
//  Created by Faannaka on 12.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {
    
    var filterPredicate: NSPredicate = NSPredicate(format: "id = id")
    var currency: Currency!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var logo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var category: Category! {
        didSet {
            let summary: Double = category.transactions.filter(filterPredicate).sum(ofProperty: "localAmount")
            
            self.label.text = category.title
            self.value.text = AmountFormatter.string(from: summary, currency: currency.desc)
            self.logo.tintColor = category.color()
            self.logo.image = category.image()
        }
    }

}
