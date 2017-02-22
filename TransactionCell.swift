//
//  TransactionCell.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var category: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var transaction: Transaction! {
        didSet {
            self.title.text = self.transaction.category?.title ?? "Incorrect category"
            self.subtitle.text = self.transaction.formattedDate()
            self.amount.text = AmountFormatter.string(from: self.transaction.amount, currency: self.transaction.account?.currency?.desc ?? "N/A")
            
            self.category.image = self.transaction.category?.image()
            self.category.tintColor = self.transaction.category?.color()
        }
    }

}
