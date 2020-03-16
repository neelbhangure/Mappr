//
//  ContributorCell.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class ContributorCell: UICollectionViewCell {
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var contributorNameLabel: UILabel!
    var contriButorDetails : ContributorElement? {
        didSet {
            contributorImageView.image = nil
            contributorNameLabel.text = contriButorDetails?.login
            contributorImageView.loadImageUsingCache(withUrl: contriButorDetails?.avatarURL ?? "")
            
        }
    }
    
}
