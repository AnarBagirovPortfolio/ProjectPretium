//
//  CategoryCell.swift
//  ProjectPretium
//
//  Created by Faannaka on 07.02.17.
//  Copyright © 2017 Anar Baghirov. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!

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
            self.name.text = self.category.title
            self.logo.image = self.category.image()
            
            self.logo.tintColor = self.category.color()
            //self.name.textColor = self.category.color()
        }
    }

}
