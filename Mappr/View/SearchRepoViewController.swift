//
//  SearchRepoViewController.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit
private let repoReuseIdentifier = "RepoCell"
class SearchRepoViewController: UIViewController {
    
    var viewModel = SearchRepoViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     setupNavBar()
        setupTableView()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RepositoryDetailViewController , let repoDetail = sender as? GitHubRepository {
            vc.repositoryDetail = repoDetail 
        }
    }
    
  @objc func  filterButtonAction() {
        
    }
}
extension SearchRepoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchRepoList(with: searchBar.text ?? "")
    }
    
}
extension SearchRepoViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: repoReuseIdentifier, for: indexPath) as?  RepositoryCell else {
            return  UITableViewCell()
        }
        cell.repo = viewModel.repoList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "RepoDetailSegue", sender: viewModel.repoList[indexPath.row])
    }
    
    
}
extension SearchRepoViewController {
    
    
    func setupNavBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FilterImage"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(filterButtonAction))
    }
    func setupTableView() {
        
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: repoReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        viewModel.reloadData = {
            self.tableView.reloadData()
        }
        
    
    }
    
}
