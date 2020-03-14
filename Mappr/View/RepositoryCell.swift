//
//  RepositoryCell.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var watcherCount: UILabel!
    
    @IBOutlet weak var commitCount: UILabel!
    
    var repo : GitHubRepository? {
        didSet {
            fullNameLabel.text =  repo?.fullName
            watcherCount.text = repo?.watchersCount?.description
            commitCount.text  = repo?.forks?.description
            nameLAbel.text =  repo?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
