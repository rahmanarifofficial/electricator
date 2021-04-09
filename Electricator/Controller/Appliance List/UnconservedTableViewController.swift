//
//  ConservedTableViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 08/04/21.
//

import UIKit

class UnconservedApplianceCell: UITableViewCell {
    @IBOutlet var applianceImage: UIImageView!
    @IBOutlet weak var applianceNameLabel: UILabel!
    @IBOutlet weak var applianceQuantityLabel: UILabel!
}

class UnconservedTableViewController: UITableViewController {
    var actionsDelegate: ApplianceActionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unconserve = UIContextualAction(style: .normal, title: "Conserve") { _,_,_ in
            self.actionsDelegate?.conserveAppliance(at: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [unconserve])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionsDelegate?.applianceTapped(at: indexPath.row, onTable: "UnconservedAppliances")
    }
}
