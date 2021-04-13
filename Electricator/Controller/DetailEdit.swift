//
//  DetailEdit.swift
//  Electricator
//
//  Created by Dzaki Izza on 08/04/21.
//

import UIKit

protocol EditingDelegate {
    func dismiss(appliance: Appliance)
}

class DetailEdit: UIViewController {
    var appliance: Appliance?
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!

    var unit: Int16?
    var chosenDuration = [
        "hour": 0,
        "minute": 0
    ]
    var unabbreviatedDay = [
        "SUN": "Sunday",
        "MON": "Monday",
        "TUE": "Tuesday",
        "WED": "Wednesday",
        "THU": "Thursday",
        "FRI": "Friday",
        "SAT": "Saturday"
    ]
    var repeatDay = [String]()
    
    var delegate: EditingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        
        setupCategoryTextField()
        setupDurationPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        prepareApplianceData()
        quantityStepper.value = Double(unit!)
    }
    
    func prepareApplianceData() {
        categoryTextField.text = appliance?.category
        typeTextField.text = appliance?.type
        powerTextField.text = String(appliance!.power)
        nameTextField.text = appliance?.name
        unit = appliance!.quantity
        quantityLabel.text = "\(unit ?? -1) Unit"
        
        let hour = appliance!.duration / 3600
        let minutes = (appliance!.duration - hour * 3600) / 60
        durationTextField.text = "\(hour)h \(minutes)m"
        chosenDuration["hour"] = Int(hour)
        chosenDuration["minute"] = Int(minutes)
        
        guard let data = appliance?.repeatDay else {
            return
        }
        var result = ""
        if data.count == 7 {
            result = "Everyday"
        } else if data.sorted() == ["MON", "TUE", "WED", "THU", "FRI"].sorted() {
            result = "Weekdays"
        } else {
            for day in data {
                result.append(" \(day)")
            }
        }
        repeatTextField.text = result
        repeatDay = (appliance?.repeatDay)!
    }
    
    @objc func doneEditing() {
        appliance?.name = nameTextField.text!
        appliance?.category = categoryTextField.text!
        appliance?.type = typeTextField.text!
        appliance?.power = Int16(powerTextField.text!)!
        appliance?.quantity = unit!
        appliance?.duration = Int32(chosenDuration["hour"]! * 3600 + chosenDuration["minute"]! * 60)
        appliance?.repeatDay = repeatDay
        
        CoreDataManager.manager.saveContext()
        
        self.delegate?.dismiss(appliance: appliance!)
    }
    
    @IBAction func categoryDidBeginEditing(sender: UITextField) {
        let storyboard = UIStoryboard(name: "AddAppliance", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CategoryList") as! CategoryListViewController
        vc.delegate = self
        
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
        categoryTextField.endEditing(true)
    }
    
    @IBAction func repeatDidBeginEditing(sender: UITextField) {
        let storyboard = UIStoryboard(name: "AddAppliance", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RepeatDayList") as! RepeatDayViewController
        vc.delegate = self
        
        var repeatDay = [
            ("Sunday", false),
            ("Monday", false),
            ("Tuesday", false),
            ("Wednesday", false),
            ("Thursday", false),
            ("Friday", false),
            ("Saturday", false)
        ]
        for day in appliance!.repeatDay! {
            for i in 0..<repeatDay.count {
                if unabbreviatedDay[day] == repeatDay[i].0 {
                    repeatDay[i].1 = true
                }
            }
        }
        
        vc.repeatDay = repeatDay
        
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
        repeatTextField.endEditing(true)
    }
    
    func setupCategoryTextField() {
        let rightChevron = UIImageView(image: UIImage(systemName: "chevron.right")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
        parentView.addSubview(rightChevron)
        
        categoryTextField.rightViewMode = .always
        categoryTextField.rightView = parentView
    }
    
    func setupDurationPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemBlue
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelToolbarTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerDoneToolbarTapped))
        
        toolbar.setItems([cancelButton, spacer, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        durationTextField.inputView = picker
        durationTextField.inputAccessoryView = toolbar
    }
    
    @IBAction func quantityStepperValueChanged(sender: UIStepper) {
        self.unit = Int16(Int(sender.value))
        quantityLabel.text = "\(self.unit ?? -1) Unit"
    }
}

extension DetailEdit: UIPickerViewDelegate, UIPickerViewDataSource {
    @objc func pickerDoneToolbarTapped() {
        let hour = chosenDuration["hour"]!
        let minute = chosenDuration["minute"]!
        
        durationTextField.text = "\(hour)h \(minute)m"
        durationTextField.endEditing(true)
    }
    
    @objc func pickerCancelToolbarTapped() {
        chosenDuration["hour"] = 0
        chosenDuration["minute"] = 0
        durationTextField.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    // This picker have 4 components (hour amount, hour label, minutes amount, and minutes label)
    // If hour amount is 24, we will reload minutes component to show only 0 minute, because we can't have 24 hours 12 minutes, etc.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Constants.Hour.count
        } else if component == 2 && pickerView.selectedRow(inComponent: 0) == 24 {
            return 1
        } else if component == 2 {
            return Constants.Minute.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(Constants.Hour[row])
        } else if component == 1 {
            return "hour"
        } else if component == 2 && pickerView.selectedRow(inComponent: 0) == 24 {
            return "0"
        } else if component == 2 {
            return String(Constants.Minute[row])
        } else {
            return "minute"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(2)
            chosenDuration["hour"] = Constants.Hour[row]
        }
        if component == 2 {
            chosenDuration["minute"] = Constants.Minute[row]
        }
    }
}

// MARK: - This extension will handle CategoryData delegate from Appliance Category view
extension DetailEdit: CategoryDataDelegate {
    func passData(data: String) {
        categoryTextField.text = data
    }
}


// MARK: - This extension will handle RepeatData delegate from Repeat Day view
extension DetailEdit: RepeatDataDelegate {
    func passData(data: [String]) {
        repeatDay = data
    
        var result = ""
        if data.count == 0 {
            result = "No Repeat"
        }else if data.count == 7 {
            result = "Everyday"
        } else if repeatDay.sorted() == ["MON", "TUE", "WED", "THU", "FRI"].sorted() {
            result = "Weekdays"
        } else {
            for day in repeatDay {
                result.append(" \(day)")
            }
        }
        
        repeatTextField.text = result
        appliance?.repeatDay = repeatDay
    }
}
