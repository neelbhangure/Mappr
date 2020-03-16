//
//  FilterTabelTableViewController.swift
//  Mappr
//
//  Created by Apple on 15/03/20.
//  Copyright © 2020 neel. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    var doneButtonPressed : ((_ language : String?) -> ())?
    let filterOptions = [ "Swift","C", "C++", "Java", "Ruby", "Go", "Python","assembly"]
    
    var previousSelectedLanguage = String()
    var selectedLanguage : String? {
        
        if let indexPath = tableView.indexPathForSelectedRow, filterOptions.count > indexPath.row {
            return filterOptions[indexPath.row]
        }
        return nil
    }
    
    fileprivate func updateTableView() {
        guard !previousSelectedLanguage.isEmpty else {
            return
        }
        for (index ,item )in filterOptions.enumerated() {
            if previousSelectedLanguage.lowercased() == item.lowercased() {
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Languages"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        tableView.register(FilterOptionsTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        updateTableView()
        
    }
    
    // MARK: - Table view data source
    
    
    @objc func donePressed() {
        if doneButtonPressed != nil  , let _ = tableView.indexPathForSelectedRow {
            
            doneButtonPressed!(selectedLanguage)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterOptions.count
    }
    
    fileprivate func isLanguageSelected(_ indexPath: IndexPath) -> Bool {
        return filterOptions[indexPath.row].lowercased() == selectedLanguage?.lowercased()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = filterOptions[indexPath.row]
        let selected = isLanguageSelected(indexPath)
        cell.setSelected(selected, animated: true)
        return cell
    }
}
