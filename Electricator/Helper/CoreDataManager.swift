//
//  CoreDataManager.swift
//  Electricator
//
//  Created by Andrean Lay on 03/04/21.
//

import UIKit
import CoreData


class CoreDataManager {
    static let manager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "HouseData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: House Core Data functions
    func insertHouse(powerSupply: Int16) -> House {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        let house = House(context: context)
        house.powerSupply = powerSupply
        
        try? context.save()
        
        return house
    }
    
    func updateHouse(to powerSupply: Int16, for house: House) {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        house.powerSupply = powerSupply
        
        try? context.save()
    }
    
    func deleteHouse(house: House) {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        context.delete(house)
    }
    
    func fetchHouse() -> House? {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        let request = House.fetchRequest() as NSFetchRequest<House>
        
        let house = try? context.fetch(request)
        
        return house?[0]
    }
    
    //MARK: Appliances Core Data functions
    func insertAppliance(name: String, category: String, type: String, power: Int16, quantity: Int16, duration: Int32, repeatDay: [String]) -> Appliance? {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        let appliance = Appliance(context: context)
        appliance.category = category
        appliance.type = type
        appliance.power = power
        appliance.name = name
        appliance.quantity = quantity
        appliance.duration = duration
        appliance.repeatDay = repeatDay
        
        let request = House.fetchRequest() as NSFetchRequest<House>
        let house = try? context.fetch(request)
        appliance.house = house?[0]
        
        try? context.save()
        
        return appliance
    }
    
    func updateAppliance(appliance: Appliance, name: String, category: String, type: String, power: Int16, quantity: Int16, duration: Int32, repeatDay: [String], conserve: Bool) {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        appliance.category = category
        appliance.type = type
        appliance.power = power
        appliance.name = name
        appliance.quantity = quantity
        appliance.duration = duration
        appliance.repeatDay = repeatDay
        appliance.conserve = conserve
        
        try? context.save()
    }
    
    func fetchAppliances() -> [Appliance] {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        
        let request = House.fetchRequest() as NSFetchRequest<House>
        let house = try? context.fetch(request)
        
        let appliances = house?[0].appliances
        
        return appliances?.allObjects as! [Appliance]
    }
    
    func deleteAppliance(appliance: Appliance) {
        let context = CoreDataManager.manager.persistentContainer.viewContext
        context.delete(appliance)
    }
    
    func flushHouse() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
        let houses = try! CoreDataManager.manager.persistentContainer.viewContext.fetch(request)
        
        for case let house as NSManagedObject in houses {
            CoreDataManager.manager.persistentContainer.viewContext.delete(house)
        }
        
        try! CoreDataManager.manager.persistentContainer.viewContext.save()
    }
    
    func flushAppliances() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Appliance")
        let appliances = try! CoreDataManager.manager.persistentContainer.viewContext.fetch(request)
        
        for case let appliance as NSManagedObject in appliances {
            CoreDataManager.manager.persistentContainer.viewContext.delete(appliance)
        }
        
        try! CoreDataManager.manager.persistentContainer.viewContext.save()
    }
}
