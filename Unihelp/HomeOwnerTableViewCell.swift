//
//  HomeOwnerTableViewCell.swift
//  Unihelp
//
//  Created by Sushanth on 4/24/17.
//  Copyright © 2017 SuProject. All rights reserved.
//

import UIKit

class HomeOwnerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var addressOfHome: UILabel!

    @IBOutlet weak var imageOfHouse: UIImageView!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
