//
//  FirstLaunchManager.swift
//  Electricator
//
//  Created by Andrean Lay on 07/04/21.
//

import Foundation

class FirstLaunchManager {
    static let shared = FirstLaunchManager()
    var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: "firstLaunch")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstLaunch")
        }
    }
}
