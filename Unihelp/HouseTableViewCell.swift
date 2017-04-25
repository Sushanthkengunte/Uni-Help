//
//  HouseTableViewCell.swift
//  Unihelp
//
//  Created by Abhijit Srikanth on 4/25/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class HouseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
