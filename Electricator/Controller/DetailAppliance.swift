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
    
    var detailsDataAppliance = ["Air Conditioner", "1/2 PK", "400 W", "AC Living Room", "1 Unit"]
    
    var detailsDataUsage = ["1 Hour", "MON TUE WED THU FRI"]
    
    var detailsRowUsage = ["Duration", "Repeat"]
    
    var detailsRowAppliance = ["Appliance Category", "Type", "Power", "Appliance Name", "Quantity"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.delegate = self
        topView.dataSource = self
        
        downView.delegate = self
        downView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action:#selector(backAction))

    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


