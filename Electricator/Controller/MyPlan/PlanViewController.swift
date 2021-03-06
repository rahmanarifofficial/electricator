//
//  ViewController.swift
//  Electricator
//
//  Created by Arif Rahman on 31/03/21.
//

import UIKit

class PlanViewController: UIViewController {
    
    @IBOutlet weak var billEstimationLabel: UILabel!
    @IBOutlet weak var monthTextView: UILabel!
    @IBOutlet weak var applianceTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var maxSlider: UILabel!
    var listAppliance = [Appliance]()
    var chosenHour = 0
    var chosenMinute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBillEstimation()
        setupView()
        setupTable()
        
        applianceTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        let house = CoreDataManager.manager.fetchHouse()
        slider.value = Float(house!.savingPlan)
        maxSlider.text = "\(Int(slider.value))%"
        
        listAppliance = CoreDataManager.manager.fetchAppliances().filter { (Appliance) -> Bool in
            Appliance.conserve == true
        }

        applianceTableView.reloadData()
        setupCurrentMonth()
        setupBillEstimation()
        setupView()
    }
    
    private func setupCurrentMonth() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: now)
        
        monthTextView.text = "\(nameOfMonth) \(year)"
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
        let message = isLock ? "Lock" : "Unlock"
        let alert = UIAlertController(
            title: "\(message) item",
            message: "Are you sure want to \(message) this item???s usage suggestion?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            CoreDataManager.manager.setApplianceLock(for: item, toLock: isLock)
            self.applianceTableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
            self.applianceTableView.reloadData()
        })
        
        self.present(alert, animated: true)
    }
    
    func convertToHourMinutes(from data: Int32) -> (String, String) {
        let hour = data / 3600
        let second = (data - hour * 3600) / 60
        
        return (String(hour), String(second))
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
    
    private func showUnableToAdjustAlert() {
        let alert = UIAlertController(title: "Unable to adjust usage", message: "Your preferred usage hours are not possible within this saving plan.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func adjustApplianceUsage(accordingTo customizedIndex: Int, newUsage usage: Int) {
        let deltaTime = (listAppliance[customizedIndex].saveHour) - Int32(usage)
        let offsetUsage = deltaTime * Int32(listAppliance[customizedIndex].power) * Int32(listAppliance[customizedIndex].quantity)
        let applianceUsageOffset = offsetUsage / Int32(listAppliance.count - 1)
        
        var adjustedUsages: [Int: Int32] = [:]
        for i in 0..<listAppliance.count {
            if i != customizedIndex && !listAppliance[i].lock {
                // We will get current appliance data first
                let currentAppliance = listAppliance[i]
                let qty = Int32(currentAppliance.quantity)
                let power = Int32(currentAppliance.power)
                let duration = currentAppliance.saveHour //Int32(currentAppliance.saveHour / 3600)
                
                // Calculate current electricity usage without customized appliance intervention
                let currentApplianceUsage = duration * power * qty
                
                // Find adjusted usage hour from previous data
                let maximumUsage = currentApplianceUsage + applianceUsageOffset
                var adjustedUsage = Double(maximumUsage / (power * qty))
                
                if maximumUsage < 0 {
                    showUnableToAdjustAlert()
                    return
                }
                adjustedUsage = (adjustedUsage / 3600 > 24 ? 24 * 3600: adjustedUsage)
                
                // Save the data to dictionary
                adjustedUsages[i] = Int32(adjustedUsage)
            }
        }
        
        // If we reach there, it means the adjusted appliances usage is possible, we need to update appliance saveHour and update the table.
        for (index, usage) in adjustedUsages {
            listAppliance[index].saveHour = usage
        }
        
        listAppliance[customizedIndex].saveHour = Int32(chosenHour + chosenMinute)
        
        applianceTableView.reloadData()
        setupBillEstimation()
        CoreDataManager.manager.saveContext()
    }
    
    @objc func pickerCancelToolbarTapped(_ sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    
    @objc func pickerDoneToolbarTapped(_ sender: UIBarButtonItem){
        let customizedIndex = sender.tag
        adjustApplianceUsage(accordingTo: customizedIndex, newUsage: chosenHour + chosenMinute)
        
        self.view.endEditing(true)
    }
    
    private func setupBillEstimation(){
        let appliances = CoreDataManager.manager.fetchAppliances()
        let myCurrent = CoreDataManager.manager.fetchHouse()?.powerSupply ?? 0
        var billEstimation: Double = 0
        for item in appliances {
            billEstimation += (calculateBillEstimation(myCurrent: Int(myCurrent), watt: Int(item.power), hours: Double(item.saveHour/3600), usage: Int(item.quantity), usageDay: item.repeatDay!.count))
        }
        let bill = "Rp\(formatNominal(billEstimation: Int(billEstimation)))".replacingOccurrences(of: ",", with: ".")
        billEstimationLabel.text = bill
    }
    
    private func calculateBillEstimation (myCurrent: Int, watt: Int, hours: Double, usage: Int, usageDay: Int) -> Double {
        
        var calculateBillEstimation: Double = 0
        if myCurrent <= 900  {
            calculateBillEstimation = Double((Double(watt) *  hours * Double(usage) * Double(usageDay)) / 1000 * 1352)
        } else if myCurrent > 900 {
            calculateBillEstimation = Double((Double(watt) * hours * Double(usage) * Double(usageDay)) / 1000 * 1444.7)
        }
        return Double(calculateBillEstimation * 4)
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let house = CoreDataManager.manager.fetchHouse()
        CoreDataManager.manager.updateSavingPlan(to: Double(sender.value), for: house!)
        maxSlider.text = "\(Int(sender.value))%"
        
        for appliance in listAppliance {
            if !appliance.lock {
                appliance.saveHour = appliance.duration - appliance.duration * Int32(sender.value)/100
            }
        }
        
        applianceTableView.reloadData()
    
        setupBillEstimation()
    }
    
    private func formatNominal(billEstimation: Int) -> String {
        var formattedNominal = ""
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        formattedNominal = fmt.string(from: NSNumber(value: billEstimation)) ?? ""
        return formattedNominal
    }
}

extension PlanViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAppliance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplianceSuggestionCell", for: indexPath) as! ApplianceTableViewCell
        
        let appliance = self.listAppliance[indexPath.row]
        let icon = Constants.ApplianceImages[appliance.category!]!
        
        cell.imageItemAppliance.image = icon
        cell.textNameAppliance.text = appliance.name
        cell.textQuantityAppliance.text = String("\(appliance.quantity) Unit")
        
        let time = convertToHourMinutes(from: appliance.saveHour)
        cell.textHourAppliance.text = String("\(time.0)h \(time.1)m")
        cell.textHourAppliance.tag = indexPath.row
        cell.textHourAppliance.inputView = durationPicker()
        cell.textHourAppliance.inputAccessoryView = durationToolbarPicker(cell.textHourAppliance)
        if appliance.lock {
            // Tampilan Jika ada appliance yang terkunci
            cell.textNameAppliance.textColor = Constants.grey
            cell.textQuantityAppliance.textColor = Constants.grey
            cell.textHourAppliance.isUserInteractionEnabled = false
            cell.textHourAppliance.textColor = Constants.grey
            cell.lockIcon.isHidden = false
        }else{
            cell.textNameAppliance.textColor = .black
            cell.textQuantityAppliance.textColor = .black
            cell.textHourAppliance.isUserInteractionEnabled = true
            cell.textHourAppliance.textColor = #colorLiteral(red: 0.007843137255, green: 0.2705882353, blue: 0.6392156863, alpha: 1)
            cell.lockIcon.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appliance = self.listAppliance[indexPath.row]
        let isLock = appliance.lock
        let message = !isLock ? "Lock" : "Unlock"
        let lockAction = UIContextualAction(style: .normal, title: message) { (action, view, onComplete) in
            if(isLock){
                self.showLockDialog(appliance, false)
            } else{
                self.showLockDialog(appliance, true)
            }
        }
        if isLock {
            lockAction.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.2705882353, blue: 0.6392156863, alpha: 1)
        }
        
        return UISwipeActionsConfiguration(actions: [lockAction])
    }
    
    
    
}

extension PlanViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Constants.HourFromOne.count
        } else {
            if chosenHour / 3600 == 24 {
                return 1
            }
            return Constants.MinuteFromZero.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String("\(Constants.HourFromOne[row]) Hour")
        } else {
            if chosenHour / 3600 == 24 {
                return String("0 Minute")
            }
            return String("\(Constants.MinuteFromZero[row]) Minute")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            chosenHour = Constants.HourFromOne[row] * 3600
            pickerView.reloadComponent(1)
        } else {
            chosenMinute = Constants.MinuteFromZero[row] * 60
        }
    }
    
}
