//
//  ApplianceListViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 07/04/21.
//

import UIKit

protocol ApplianceActionsDelegate {
    func conserveAppliance(at index: Int)
    func unconserveAppliance(at index: Int)
    func deleteAppliance(at index: Int)
}

class ApplianceListViewController: UIViewController {
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var noApplianceImage: UIImageView!
    @IBOutlet weak var conserveGuideImage: UIImageView!
    @IBOutlet weak var appliancesContainer: UIView!
    @IBOutlet weak var conservedAppliancesContainer: UIView!
    @IBOutlet weak var nonConserveLabel: UILabel!
    
    var applianceTableView: UITableViewController!
    var conservedTableView: UITableViewController!
    
    var appliances = [Appliance]()
    var unconservedAppliances = [Appliance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton.layer.transform = CATransform3DMakeScale(2.0, 2.0, 2.0)
        
        applianceTableView.tableView.dataSource = self
        conservedTableView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAppliance()
        checkForGuidestoShow()
    }
    
    func checkForGuidestoShow() {
        let noAppliances = appliances.isEmpty
        let noConservedAppliances = unconservedAppliances.isEmpty
        
        print("Appliances: \(noAppliances)")
        print("Non conserve: \(noConservedAppliances)")
        
        appliancesContainer.isHidden = noAppliances && noConservedAppliances
        conservedAppliancesContainer.isHidden = noConservedAppliances
        noApplianceImage.isHidden = !(noAppliances && noConservedAppliances)
        nonConserveLabel.isHidden = !noApplianceImage.isHidden
        conserveGuideImage.isHidden = noApplianceImage.isHidden && !noConservedAppliances
    }
    
    func fetchAppliance() {
        print("Fetching data..")
        let fetchedAppliances = CoreDataManager.manager.fetchAppliances()
        
        appliances = fetchedAppliances.filter({ appliance in
            return appliance.conserve == true
        })
        
        unconservedAppliances = fetchedAppliances.filter({ appliance in
            return appliance.conserve == false
        })
    }
    
    @IBAction func plusButtonTapped() {
        let storyboard = UIStoryboard(name: "AddAppliance", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddApplianceVC") as? AddApplianceViewController
        vc?.delegate = self
        let navController = UINavigationController(rootViewController: vc!)
        present(navController, animated: true, completion: nil)
    }
    
    func updateTable() {
        fetchAppliance()
        applianceTableView.tableView.reloadData()
        conservedTableView.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddApplianceSegue" {
            if let vc = segue.destination as? AddApplianceViewController {
                vc.delegate = self
            }
        }
        if segue.identifier == "ApplianceListSegue" {
            applianceTableView = segue.destination as? UITableViewController
            (segue.destination as? AppliancesTableViewController)?.actionsDelegate = self
        }
        if segue.identifier == "ConservedApplianceSegue" {
            conservedTableView = segue.destination as? UITableViewController
            (segue.destination as? UnconservedTableViewController)?.actionsDelegate = self
        }
    }
}

extension ApplianceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(applianceTableView.tableView) {
            return appliances.count
        } else {
            return unconservedAppliances.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(applianceTableView.tableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplianceCell") as? ApplianceCell
            
            
            let icon = Constants.ApplianceImages[appliances[indexPath.row].category!]!?.withTintColor(Constants.darkBlue, renderingMode: .alwaysOriginal)
            cell?.applianceImage.image = icon
            cell?.applianceNameLabel.text = appliances[indexPath.row].name
            cell?.applianceQuantityLabel.text = "\(appliances[indexPath.row].quantity) Unit"
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnconservedApplianceCell") as? UnconservedApplianceCell
            
            let icon = Constants.ApplianceImages[unconservedAppliances[indexPath.row].category!]!?.withTintColor(Constants.darkBlue, renderingMode: .alwaysOriginal)
            cell?.applianceImage.image = icon
            cell?.applianceNameLabel.text = unconservedAppliances[indexPath.row].name
            cell?.applianceQuantityLabel.text = "\(unconservedAppliances[indexPath.row].quantity) Unit"
            
            return cell!
        }
    }
    
}

extension ApplianceListViewController: AddApplianceControllerDelegate {
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
        fetchAppliance()
        applianceTableView.tableView.reloadData()
    }
}

extension ApplianceListViewController: ApplianceActionsDelegate {
    func showAlert(for title: String, yesAction rightHand: String, isDestructive: Bool, action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "\(title) Item", message: "Are you sure want to \(title) this item ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss()
        }
        var yesAction: UIAlertAction?
        if isDestructive {
            yesAction = UIAlertAction(title: rightHand, style: .destructive, handler: action)
        } else {
            yesAction = UIAlertAction(title: rightHand, style: .default, handler: action)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction!)
        
        present(alert, animated: true)
    }
    
    func conserveAppliance(at index: Int) {
        showAlert(for: "Conserve", yesAction: "Yes", isDestructive: false) { _ in
            CoreDataManager.manager.setApplianceConservation(for: self.unconservedAppliances[index], toConserve: true)
            self.updateTable()
            
            self.checkForGuidestoShow()
        }
    }
    
    func unconserveAppliance(at index: Int) {
        showAlert(for: "Unconserve", yesAction: "Yes", isDestructive: false) { _ in            CoreDataManager.manager.setApplianceConservation(for: self.appliances[index], toConserve: false)
            self.updateTable()
            
            self.checkForGuidestoShow()
        }
    }
    
    func deleteAppliance(at index: Int) {
        showAlert(for: "Delete", yesAction: "Delete", isDestructive: true) { _ in              CoreDataManager.manager.deleteAppliance(appliance: self.appliances[index])
            
            self.fetchAppliance()
            self.applianceTableView.tableView.reloadData()
        }
    }
}
