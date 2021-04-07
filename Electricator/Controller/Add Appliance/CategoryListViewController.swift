//
//  CategoryListViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 06/04/21.
//

import UIKit

protocol CategoryDataDelegate {
    func passData(data: String)
}

class CategoryCell: UITableViewCell {
    @IBOutlet var categoryLabel: UILabel!
}

class CategoryListViewController: UITableViewController {
    @IBOutlet var categoryTableView: UITableView!
    
    var delegate: CategoryDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    func setupNavBar() {
        title = "Choose category"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ApplianceCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        let categoryName = Constants.ApplianceCategory[indexPath.row]
        cell.categoryLabel.text = categoryName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenCategory = Constants.ApplianceCategory[indexPath.row]
        delegate?.passData(data: chosenCategory)
        
        self.dismiss(animated: true, completion: nil)
    }
}
