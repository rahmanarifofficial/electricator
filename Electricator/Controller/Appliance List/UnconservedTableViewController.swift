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
        
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let conserve = UIContextualAction(style: .normal, title: "Conserve") { _,_,_ in
            self.actionsDelegate?.conserveAppliance(at: indexPath.row)
        }
        conserve.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.2705882353, blue: 0.6392156863, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [conserve])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionsDelegate?.applianceTapped(at: indexPath.row, onTable: "UnconservedAppliances")
    }
}
