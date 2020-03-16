//
//  RepositoryDetailViewController.swift
//  Mappr
//
//  Created by neel on 14/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit
import SafariServices
private let contributorReuseIdentifier = "ContributorCell"
class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var viewModel = ContributorViewModel()
    
    
    fileprivate func updateView() {
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        descriptionTextView.layer.borderWidth = 1
        nameLabel.text = viewModel.repositoryDetail?.name
        descriptionTextView.text = viewModel.repositoryDetail?.description
        repoImageView.loadImageUsingCache(withUrl: viewModel.repositoryDetail?.owner?.avatarUrl ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateView()
        if let contributerURL = URL(string: viewModel.repositoryDetail?.contributersUrl ?? "") {
            viewModel.getContributorList(withURL: contributerURL)
            
        }
    }
    
   
    
    deinit {
        self.collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contributorDetailsViewController = segue.destination as? ContributorDetailsViewController , let contributorDetail = sender as? ContributorElement {
            contributorDetailsViewController.title = contributorDetail.login
            contributorDetailsViewController.viewModel.contributorDetail = contributorDetail
        }
    }
    
    
    @IBAction func projectLinkButtonAction(_ sender: Any) {
        let url = URL(string: viewModel.repositoryDetail?.url ?? "")!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
}

extension RepositoryDetailViewController: UICollectionViewDataSource,UICollectionViewDelegate, SFSafariViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.listCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contributorReuseIdentifier, for: indexPath) as! ContributorCell
        cell.contriButorDetails = viewModel.contributorList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ContributerSegue", sender: viewModel.contributorList[indexPath.item])
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "ContributorCell", bundle: nil), forCellWithReuseIdentifier: contributorReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 180, height: 180)
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        viewModel.reloadData = {
            [weak self] in
            self?.collectionView.reloadData()
        }
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
          if let obj = object as? UICollectionView {
             if obj == self.collectionView && keyPath == "contentSize" {
                 if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    viewHeightConstraint.constant = newSize.height + 550
                 }
             }
         }
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
