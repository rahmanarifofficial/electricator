//
//  Constants.swift
//  Electricator
//
//  Created by Andrean Lay on 06/04/21.
//

import UIKit
import Foundation

struct ApplianceDefaultData {
    var type: String?
    var power: Int16?
}

struct Constants {
    static let ApplianceCategory = ["Air Conditioner", "Rice Cooker", "Refrigerator", "Television", "Light", "Charger", "Water Dispenser", "Printer", "Fan", "Hair Dryer", "Iron"]
    static let ApplianceImages = [
        "Air Conditioner": UIImage(named: "ic-air-conditioner"),
        "Rice Cooker": UIImage(named: "ic-rice-cooker"),
        "Refrigerator": UIImage(named: "ic-refrigerator"),
        "Television": UIImage(named: "ic-television"),
        "Light": UIImage(named: "ic-light"),
        "Charger": UIImage(named: "ic-charger"),
        "Water Dispenser": UIImage(named: "ic-water-dispenser"),
        "Printer": UIImage(named: "ic-printer"),
        "Fan": UIImage(named: "ic-fan"),
        "Hair Dryer": UIImage(named: "ic-hair-dryer"),
        "Iron": UIImage(named: "ic-iron")
    ]
    static let AppliancesDefaultData = [
        "Air Conditioner": ApplianceDefaultData(type: "1/2 PK", power: 400),
        "Rice Cooker": ApplianceDefaultData(type: nil, power: 400),
        "Refrigerator": ApplianceDefaultData(type: "Two Door", power: 100),
        "Television": ApplianceDefaultData(type: "24 inch", power: 35),
        "Light": ApplianceDefaultData(type: "LED", power: 10),
        "Charger": ApplianceDefaultData(type: nil, power: nil),
        "Water Dispenser": ApplianceDefaultData(type: "Top Load", power: 190),
        "Printer": ApplianceDefaultData(type: "Inkjet", power: 30),
        "Fan": ApplianceDefaultData(type: "Stand", power: 50),
        "Hair Dryer": ApplianceDefaultData(type: nil, power: 400),
        "Iron": ApplianceDefaultData(type: nil, power: 400)
    ]
    
    static let Hour = Array(0...24)
    static let HourFromOne = Array(1...24)
    static let MinuteFromZero = Array(0...59)
    static let Minute = Array(0...60)
    
    static let darkBlue = UIColor(red: 2/255, green: 69/255, blue: 163/255, alpha: 1)
    static let grey = UIColor(red: 161/255, green: 169/255, blue: 181/255, alpha: 1)
}
