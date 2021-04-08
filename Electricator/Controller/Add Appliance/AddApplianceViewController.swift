//
//  AddApplianceViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 06/04/21.
//

import UIKit

protocol AddApplianceControllerDelegate {
    func dismiss()
}

class AddApplianceViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    
    var unit = 1
    var chosenDuration = [
        "hour": 0,
        "minute": 0
    ]
    var repeatDay = [String]()
    
    var delegate: AddApplianceControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupDurationPicker()
        setupCategoryTextField()
    }
    
    func setupCategoryTextField() {
        let rightChevron = UIImageView(image: UIImage(systemName: "chevron.right")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
        parentView.addSubview(rightChevron)
        
        categoryTextField.rightViewMode = .always
        categoryTextField.rightView = parentView
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
        
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
        repeatTextField.endEditing(true)
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
    
    func setupNavBar() {
        title = "Add New Appliance"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc func closeButtonTapped() {
        self.delegate?.dismiss()
    }
    
    @objc func saveButtonTapped() {
        let name = nameTextField.text!
        let category = categoryTextField.text!
        let type = typeTextField.text!
        let power = Int16(powerTextField.text!)!
        let quantity = Int16(unit)
        let duration = Int32(chosenDuration["hour"]! * 3600 + chosenDuration["minute"]! * 60)
        
        
        _ = CoreDataManager.manager.insertAppliance(name: name, category: category, type: type, power: power, quantity: quantity, duration: duration, repeatDay: repeatDay)
        
        self.delegate?.dismiss()
    }
    
    @IBAction func quantityStepperValueChanged(sender: UIStepper) {
        self.unit = Int(sender.value)
        quantityLabel.text = "\(self.unit) Unit"
    }
}

extension AddApplianceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    @objc func pickerDoneToolbarTapped() {
        let hour = chosenDuration["hour"]!
        let minute = chosenDuration["minute"]!
        
        durationTextField.text = "\(hour) hours \(minute) minutes"
        durationTextField.endEditing(true)
    }
    
    @objc func pickerCancelToolbarTapped() {
        chosenDuration["hour"] = -1
        chosenDuration["minute"] = -1
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
extension AddApplianceViewController: CategoryDataDelegate {
    func passData(data: String) {
        categoryTextField.text = data
    }
}


// MARK: - This extension will handle RepeatData delegate from Repeat Day view
extension AddApplianceViewController: RepeatDataDelegate {
    func passData(data: [String]) {
        repeatDay = data
        
        var result = ""
        if data.count == 7 {
            result = "Everyday"
        } else if repeatDay.sorted() == ["MON", "TUE", "WED", "THU", "FRI"].sorted() {
            result = "Weekdays"
        } else {
            for day in repeatDay {
                result.append(" \(day)")
            }
        }
        
        repeatTextField.text = result
    }
}
