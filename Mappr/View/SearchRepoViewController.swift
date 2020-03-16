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
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = SearchRepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController, let repoDetail = sender as? GitHubRepository {
            repositoryDetailViewController.viewModel.repositoryDetail = repoDetail
        }
    }
    
    @objc func  filterButtonAction() {
        let filterTableViewController = FilterTableViewController()
        filterTableViewController.previousSelectedLanguage = viewModel.filterLanguage ?? ""
        let navigationController = UINavigationController(rootViewController: filterTableViewController)
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        navigationController.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: {
            filterTableViewController.doneButtonPressed = { [weak self] language in
                guard let self = self else { return }
                guard self.viewModel.filterLanguage != language else {
                    return
                }
                self.viewModel.filterLanguage = language
                self.dismiss(animated: true, completion: nil)
                self.viewModel.repoList = []
                self.tableView.reloadData()
                let searchBar = self.navigationItem.titleView as? UISearchBar
                self.viewModel.searchRepoList(searchString: searchBar?.text ?? "")
            }
        })
        
    }
}

extension SearchRepoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.searchRepoList(searchString: searchBar.text ?? "")
        (navigationItem.titleView as? UISearchBar)?.resignFirstResponder()
    }
}

extension SearchRepoViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.listCount > indexPath.row, let cell = tableView.dequeueReusableCell(withIdentifier: repoReuseIdentifier, for: indexPath) as? RepositoryCell {
            cell.repo = viewModel.repoList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.listCount > indexPath.row {
            performSegue(withIdentifier: "RepoDetailSegue", sender: viewModel.repoList[indexPath.row])
        }
    }
}

extension SearchRepoViewController {
    
    private func setupNavBar() {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "FilterImage"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(filterButtonAction))
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: repoReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.reloadData = {
             [weak self] in
            self?.tableView.reloadData()
        }
    }
}
