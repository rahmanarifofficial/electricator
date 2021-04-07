//
//  SecondController.swift
//  Electricator Project Dzaki
//
//  Created by Dzaki Izza on 05/04/21.
//

import Foundation
import UIKit

class FirstSetupViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!

    let data = [
        ("450 VA", 450),
        ("900 VA", 900),
        ("1300 VA", 1300),
        ("2200 VA", 2200),
        ("3500 VA", 3500),
        ("5500 VA", 5500),
        ("6600 VA", 6600),
    ]
    var selectedCurrent = 450
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker.delegate = self
        
        saveButton.layer.cornerRadius = 7 
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action:#selector(backAction))
    }
    
    @objc func backAction(){
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        _ = CoreDataManager.manager.insertHouse(powerSupply: Int16(selectedCurrent))
        FirstLaunchManager.shared.isFirstLaunch = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrent = data[row].1
    }
}
