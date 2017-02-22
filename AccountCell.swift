//
//  AccountCell.swift
//  ProjectPretium
//
//  Created by Faannaka on 05.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var balance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var account: Account! {
        didSet {
            self.title.text = self.account.title
            self.balance.text = AmountFormatter.string(from: self.account.amount, currency: self.account.currency?.desc ?? "")
        }
    }

}
