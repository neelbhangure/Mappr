//
//  ContributorViewModel.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import Foundation

class ContributorViewModel {
    var reloadData : (() -> ())?
    
     var repositoryDetail : GitHubRepository?
    var contributorList = ContributerList()
    
    
    var listCount : Int {
        get {
            return  contributorList.count
        }
    }
    
    func getContributorList(withURL url : URL) {
        GitHubApi.shared.getContributersList(withUrl: url, successHandler: { [weak self] (list) in
            self?.contributorList = list
            if let reloadData = self?.reloadData {
                reloadData()
            }
        }) { (err) in
            
        }
    }
    
}
