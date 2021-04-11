//
//  ViewController.swift
//  Electricator
//
//  Created by Arif Rahman on 31/03/21.
//

import UIKit

class PlanViewController: UIViewController {
    
    @IBOutlet weak var billEstimationLabel: UILabel!
    @IBOutlet weak var applianceTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var listAppliance = [Appliance]()
    var choosenDuration = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBillEstimation()
        setupView()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listAppliance = CoreDataManager.manager.fetchAppliances().filter { (Appliance) -> Bool in
            Appliance.conserve == true
        }
        applianceTableView.reloadData()
        setupBillEstimation()
        setupView()
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
    
    private func showLockDialog(_ item: Appliance, _ isLock:Bool){
        let alert = UIAlertController(
            title: "Lock Item",
            message: "Are you sure want to lock this item’s usage suggestion?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            CoreDataManager.manager.setApplianceLock(for: item, toLock: isLock)
            self.applianceTableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true)
    }
    
    func durationPicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }
    
    func durationToolbarPicker(_ sender: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemBlue
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(pickerCancelToolbarTapped))
        cancelButton.tag = sender.tag
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerDoneToolbarTapped(_:)))
        doneButton.tag = sender.tag
        toolbar.setItems([cancelButton, spacer, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func pickerCancelToolbarTapped(_ sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    
    @objc private func pickerDoneToolbarTapped(_ sender: UIBarButtonItem){
        print("row: \(sender.tag)")
        listAppliance[sender.tag].saveHour = Int32(choosenDuration * 3600)
        // Add recalculate here
        applianceTableView.reloadData()
        
        self.view.endEditing(true)
    }
    
    private func setupBillEstimation(){
        listAppliance = CoreDataManager.manager.fetchAppliances()
        let myCurrent = CoreDataManager.manager.fetchHouse()?.powerSupply ?? 0
        var billEstimation: Double = 0
        for item in listAppliance {
            billEstimation += (calculateBillEstimation(myCurrent: Int(myCurrent), watt: Int(item.power), hours: Double(item.duration/3600), usage: Int(item.quantity)))
        }
        billEstimationLabel.text = "Rp\(String(billEstimation))"
    }
    
    private func calculateBillEstimation (myCurrent: Int, watt: Int, hours: Double, usage: Int) -> Double {
        
        var calculateBillEstimation: Double = 0
        if myCurrent <= 900  {
            calculateBillEstimation = Double((Double(watt)*hours*Double(usage))/1000*1352)
        } else if myCurrent > 900 {
            calculateBillEstimation = Double((Double(watt)*hours*Double(usage))/1000*1444.7)
        }
        return Double(calculateBillEstimation*30)
    }
}

extension PlanViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAppliance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplianceSuggestionCell", for: indexPath) as! ApplianceTableViewCell
        
        let appliance = self.listAppliance[indexPath.row]
        let icon = Constants.ApplianceImages[appliance.category!]!?.withTintColor(appliance.lock ? Constants.grey : Constants.darkBlue, renderingMode: .alwaysOriginal)
        
        cell.imageItemAppliance.image = icon
        cell.textNameAppliance.text = appliance.name
        cell.textQuantityAppliance.text = String("\(appliance.quantity) Unit")
        let duration = appliance.saveHour == -1 ? appliance.duration : appliance.saveHour
        cell.textHourAppliance.text = String("\(duration / 3600 )h")
        cell.textFinalHourAppliance.text = String("\(appliance.duration / 3600)h")
        cell.textHourAppliance.tag = indexPath.row
        cell.textHourAppliance.inputView = durationPicker()
        cell.textHourAppliance.inputAccessoryView = durationToolbarPicker(cell.textHourAppliance)
        if appliance.lock {
            // Tampilan Jika ada appliance yang terkunci
            cell.textNameAppliance.textColor = Constants.grey
            cell.textQuantityAppliance.textColor = Constants.grey
            cell.textHourAppliance.isUserInteractionEnabled = false
            cell.lockIcon.isHidden = false
        }else{
            cell.textNameAppliance.textColor = .black
            cell.textQuantityAppliance.textColor = .black
            cell.textHourAppliance.isUserInteractionEnabled = true
            cell.lockIcon.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appliance = self.listAppliance[indexPath.row]
        let lockAction = UIContextualAction(style: .normal, title: "Lock") { (action, view, onComplete) in
            if(appliance.lock){
                self.showLockDialog(appliance, false)
            } else{
                self.showLockDialog(appliance, true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [lockAction])
    }
}

extension PlanViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.HourFromOne.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String("\(Constants.HourFromOne[row]) Hour")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosenDuration = Constants.HourFromOne[row]
    }
    
}
