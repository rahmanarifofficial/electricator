//
//  DetailAppliance.swift
//  Electricator
//
//  Created by Dzaki Izza on 08/04/21.
//

import UIKit

class DetailAppliance: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topView: UITableView!
    @IBOutlet weak var downView: UITableView!
    
    var appliance: Appliance?
    
    var detailsDataAppliance = ["Air Conditioner", "1/2 PK", "400 W", "AC Living Room", "1 Unit"]
    
    var detailsDataUsage = ["1 Hour", "MON TUE WED THU FRI"]
    
    var detailsRowUsage = ["Duration", "Repeat"]
    
    var detailsRowAppliance = ["Appliance Category", "Type", "Power", "Appliance Name", "Quantity"]
    
    var detailsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.delegate = self
        topView.dataSource = self
        
        downView.delegate = self
        downView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        prepareApplianceData()
    }
    
    func prepareApplianceData() {
        detailsDataAppliance[0] = appliance?.category ?? "Category not available"
        detailsDataAppliance[1] = appliance?.type ?? "Type not available"
        detailsDataAppliance[2] = "\(appliance?.power ?? -1) W"
        detailsDataAppliance[3] = appliance?.name ?? "Name not available"
        detailsDataAppliance[4] = "\(appliance?.quantity ?? -1) Unit"
        
        let duration = Int(appliance!.duration)
        let hour = duration / 3600
        detailsDataUsage[0] = "\(hour) hours \((duration - hour * 3600) / 60) minutes"
        detailsDataUsage[1] = (appliance?.repeatDay?.joined(separator: " "))!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ApplianceEditSegue" {
            let destination = segue.destination as? DetailEdit
            destination?.appliance = appliance
            destination?.delegate = self
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ApplianceEditSegue", sender: self)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        var cell = UITableViewCell()

        switch tableView {
        
        case topView :
            cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            cell.textLabel?.text = detailsRowAppliance[indexPath.row]
            cell.detailTextLabel?.text = detailsDataAppliance[indexPath.row]
            cell.detailTextLabel?.textColor = .lightGray
        
        case downView :
            cell = tableView.dequeueReusableCell(withIdentifier: "downCell", for: indexPath)
            cell.textLabel?.text = detailsRowUsage[indexPath.row]
            cell.detailTextLabel?.text = detailsDataUsage[indexPath.row]
            cell.detailTextLabel?.textColor = .lightGray

        default :
            
        print(" ")
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount = 1
        
        switch tableView {
        
        case topView:
            rowCount = detailsDataAppliance.count
        
        case downView :
            rowCount = detailsDataUsage.count
        
        default :
            print(" ")
        }
        
        return rowCount
    }
}

extension DetailAppliance: EditingDelegate {
    func dismiss(appliance: Appliance) {
        self.navigationController?.popViewController(animated: true)
        self.appliance = appliance
        topView.reloadData()
        downView.reloadData()
        
        detailsChanged = true
    }
}
