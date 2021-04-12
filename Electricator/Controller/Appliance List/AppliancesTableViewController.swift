//
//  AppliancesTableViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 08/04/21.
//

import UIKit

class ApplianceCell: UITableViewCell {
    @IBOutlet var applianceImage: UIImageView!
    @IBOutlet weak var applianceNameLabel: UILabel!
    @IBOutlet weak var applianceQuantityLabel: UILabel!
}

class AppliancesTableViewController: UITableViewController {
    var actionsDelegate: ApplianceActionsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unconserve = UIContextualAction(style: .normal, title: "Unconserve") { _,_,_ in
            self.actionsDelegate?.unconserveAppliance(at: indexPath.row)
        }
        unconserve.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.2705882353, blue: 0.6392156863, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [unconserve])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.actionsDelegate?.deleteAppliance(at: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionsDelegate?.applianceTapped(at: indexPath.row, onTable: "ApplianceList")
    }
}
