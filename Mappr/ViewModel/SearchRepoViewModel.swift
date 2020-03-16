//
//  SearchRepoViewModel.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import Foundation
class SearchRepoViewModel {
    
    var reloadData: (() -> ())?
    var repoList = [GitHubRepository]()
    var filterLanguage : String?
    
    var listCount : Int {
        get {
            return repoList.count
        }
    }
    
    func searchRepoList(searchString : String) {
        guard !searchString.isEmpty else{
            return
        }
        var query = searchString
        if let language = filterLanguage ,  !language.isEmpty {
            query = query + "+language:\(language)"
        }
        GitHubApi.shared.searchRepos(searchWith: query, params: [:], successHandler: { [weak self] (results)  in
            let list = Array(results.items.prefix(10)).sorted(by: { $0.watchersCount  > $1.watchersCount } )
            self?.repoList = list
            if let reloadData = self?.reloadData {
                reloadData()
            }
            
//            print(results)
        }) { (err) in
            
        }
    }
    
}
