//
//  FilterOptionsTableViewCell.swift
//  Mappr
//
//  Created by Apple on 15/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class FilterOptionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        // Configure the view for the selected state
    }

}
