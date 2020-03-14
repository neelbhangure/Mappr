//
//  SearchRepoViewModel.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import Foundation
class SearchRepoViewModel {
  var reloadData : (() -> ())?
    var repoList = [GitHubRepository]()
 
    var listCount : Int {
        get {
       return  repoList.count
        }
    }
    
    func searchRepoList(with : String) {
        GitHubApi.shared.searchRepos(searchWith: with, params: [:], successHandler: { [weak self] (results)  in
            self?.repoList = results.items
            if let reloadData = self?.reloadData {
               reloadData()
            }
           
            print(results)
        }) { (err) in
             
        }
    }
    
}
