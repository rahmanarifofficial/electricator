//
//  SettingViewController.swift
//  Electricator
//
//  Created by Dzaki Izza on 09/04/21.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var notifView: UITableView!
    @IBOutlet weak var powerField: UITextField!
    
    
    let powerPicker = UIPickerView()
    
    var powerData = ["450 VA", "900 VA", "1300 VA", "2200 VA", "3500 VA", "5500 VA", "6600 VA"]
    var selectedPower: String?
    
    var switchState = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notifView.delegate = self
        notifView.dataSource = self
        
        powerPicker.delegate = self
        powerPicker.dataSource = self
        
        toolBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let current = CoreDataManager.manager.fetchHouse()?.powerSupply
        powerField.text = "\(current!) VA"
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath)
        cell.textLabel?.text = "Push Notification"
        cell.textLabel?.textColor = UIColor(rgb: 0x06224A)
        let swtch = UISwitch()
        swtch.setOn(false, animated: true)
        swtch.tag = 1
        swtch.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControl.Event.valueChanged)
        
        cell.accessoryView = swtch
        
        
        return cell
        
    }
    
    func createNewNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder"
        content.body = "Reduce your electricity usage"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "swtch", content: content, trigger: trigger )
        center.add(request) { (error) in
            if error != nil{
                
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
    
    
    @objc func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { setting in
                if setting.authorizationStatus == .denied {
                    DispatchQueue.main.async {
                        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
                        if !isRegisteredForRemoteNotifications {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    }
                    
                } else if setting.authorizationStatus == .notDetermined {
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                        if let error = error {
                            print(error)
                        }
                        if granted {
                            self.createNewNotification()
                        } else {
                            DispatchQueue.main.async {
                                print("Called")
                                sender.isOn = false
                            }
                        }
                    }
                } else if setting.authorizationStatus == .authorized {
                    self.createNewNotification()
                }
            }
        } else {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            print("no")
        }
        
        
    }
    
    func toolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        powerField.inputAccessoryView = toolBar
        powerField.textAlignment = .center
        powerField.inputView = powerPicker
        powerField.font = UIFont.systemFont(ofSize: 17)
        powerField.textColor = UIColor(rgb: 0x0245A3)
        powerField.attributedPlaceholder = NSAttributedString(string: "1300 VA",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x0245A3)])
        powerField.layer.borderWidth = 1.0
        powerField.layer.borderColor = UIColor.white.cgColor
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([cancel, spacer, doneBtn], animated: true)
        
        
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    @objc func donePressed() {
        let house = CoreDataManager.manager.fetchHouse()
        let power = Int16((selectedPower!.components(separatedBy: " ")[0]))!
        CoreDataManager.manager.updateHouse(to: power, for: house!)
        self.powerField.text = selectedPower
        
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return powerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return powerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPower = powerData[row]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
