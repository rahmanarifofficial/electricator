//
//  Constants.swift
//  Electricator
//
//  Created by Andrean Lay on 06/04/21.
//

import UIKit
import Foundation

struct Constants {
    static let ApplianceCategory = ["Air Conditioner", "Rice Cooker", "Refrigerator", "Television", "Light", "Charger", "Water Heater", "Printer", "Fan", "Hair Dryer", "Iron"]
    static let ApplianceImages = [
        "Air Conditioner": UIImage(named: "ic-air-conditioner"),
        "Rice Cooker": UIImage(named: "ic-rice-cooker"),
        "Refrigerator": UIImage(named: "ic-refrigerator"),
        "Television": UIImage(named: "ic-television"),
        "Light": UIImage(named: "ic-light"),
        "Charger": UIImage(named: "ic-charger"),
        "Water Heater": UIImage(named: "ic-water-heater"),
        "Printer": UIImage(named: "ic-printer"),
        "Fan": UIImage(named: "ic-fan"),
        "Hair Dryer": UIImage(named: "ic-hair-dryer"),
        "Iron": UIImage(named: "ic-iron")
    ]
    static let Hour = Array(0...24)
    static let HourFromOne = Array(1...24)
    static let Minute = Array(0...60)
    
    static let darkBlue = UIColor(red: 2/255, green: 69/255, blue: 163/255, alpha: 1)
}
