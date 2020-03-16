//
//  ContributorDetailsViewController.swift
//  Mappr
//
//  Created by Apple on 15/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class ContributorDetailsViewController: UIViewController {
    
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var contributorTableView: UITableView!
    var viewModel = ContributorDetailviewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        contributorImageView.loadImageUsingCache(withUrl: viewModel.contributorDetail?.avatarURL ?? "")
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        contributorTableView.delegate = self
        contributorTableView.dataSource = self
        contributorTableView.estimatedRowHeight = 40
        contributorTableView.rowHeight = UITableView.automaticDimension
        contributorTableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        if let contributerRepoURL = URL(string: viewModel.contributorDetail?.reposURL ?? "") {
            
            viewModel.getContributorRepoList(withURL: contributerRepoURL)
        }
        viewModel.reloadData = { [weak self] in
            self?.contributorTableView.reloadData()
        }
    }
    
    
}
extension ContributorDetailsViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.repoListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        cell.repo = viewModel.contributorRepoList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repositoryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RepositoryDetailViewController") as! RepositoryDetailViewController
        repositoryDetailViewController.viewModel.repositoryDetail =  viewModel.contributorRepoList[indexPath.row]
        self.navigationController?.pushViewController(repositoryDetailViewController, animated: true)
        
    }
    
}
