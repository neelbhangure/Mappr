//
//  RepositoryCell.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    //MARK:- IBOutlet property
    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var watcherCount: UILabel!
    @IBOutlet weak var commitCount: UILabel!
    
    ///property Observer
    var repo: GitHubRepository? {
        didSet {
            avtarImageView.image = nil
            fullNameLabel.text =  repo?.fullName
            watcherCount.text = repo?.watchersCount.description
            commitCount.text  = repo?.forks?.description
            nameLAbel.text =  repo?.name
            avtarImageView.loadImageUsingCache(withUrl: repo?.owner?.avatarUrl ?? "")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
