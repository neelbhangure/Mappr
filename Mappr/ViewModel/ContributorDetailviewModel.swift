//
//  ContributorDetailviewModel.swift
//  Mappr
//
//  Created by Apple on 15/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import Foundation
class ContributorDetailviewModel  {
    
    var reloadData : (() -> ())?
    var contributorRepoList = [GitHubRepository]()
    var contributorDetail : ContributorElement?
    
    var repoListCount : Int {
        get {
            return  contributorRepoList.count
        }
    }
    func getContributorRepoList(withURL url : URL)  {
        GitHubApi.shared.getContributersRepoList(withUrl: url, successHandler: { [weak self] (repoList) in
            self?.contributorRepoList = repoList
            if let reloadData = self?.reloadData {
                reloadData()
            }
        }) { (err) in
            
        }
    }
}
