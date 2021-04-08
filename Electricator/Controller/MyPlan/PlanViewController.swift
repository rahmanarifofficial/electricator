//
//  ViewController.swift
//  Electricator
//
//  Created by Arif Rahman on 31/03/21.
//

import UIKit

class PlanViewController: UIViewController {
    
    @IBOutlet weak var applianceTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    let listAppliance = CoreDataManager.manager.fetchAppliances()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupTable()
    }
    
    private func setupView(){
        if dataIsExist() {
            emptyView.isHidden = true
            applianceTableView.isHidden = false
        }else{
            emptyView.isHidden = false
            applianceTableView.isHidden = true
        }
    }
    
    private func dataIsExist() -> Bool {
        if listAppliance.isEmpty {
            return false
        }else{
            return true
        }
    }
    
    private func setupTable(){
        applianceTableView.dataSource = self
        applianceTableView.delegate = self
        applianceTableView.register(UINib(nibName: "ApplianceTableViewCell", bundle: nil), forCellReuseIdentifier: "ApplianceSuggestionCell")
    }
    
    private func showLockDialog(_ item: Appliance){
        let alert = UIAlertController(
            title: "Lock Item",
            message: "Are you sure want to lock this item’s usage suggestion?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            print("Lock Item.")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel lock item.")
        })
        
        self.present(alert, animated: true)
    }
    
}

extension PlanViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAppliance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplianceSuggestionCell", for: indexPath) as! ApplianceTableViewCell
        
        let appliance = self.listAppliance[indexPath.row]
        cell.textNameAppliance.text = appliance.name
        cell.textQuantityAppliance.text = String("\(appliance.quantity) Unit")
        cell.textHourAppliance.text = String("\(appliance.duration)")
        cell.lockHourViewAppliance.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appliance = self.listAppliance[indexPath.row]
        let lockAction = UIContextualAction(style: .normal, title: "Lock") { (action, view, onComplete) in
            self.showLockDialog(appliance)
        }
        lockAction.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [lockAction])
    }
}


