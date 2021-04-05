//
//  CoreDataTests.swift
//  ElectricatorTests
//
//  Created by Andrean Lay on 03/04/21.
//

import XCTest
import CoreData
@testable import Electricator

class CoreDataTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = CoreDataManager.manager
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: - Test cases for Core Data
    func test_init_coreDataManager() {
        let manager = CoreDataManager.manager
        
        XCTAssertNotNil(manager)
    }
    
    func test_coreDataContainerInitialization() {
        let container = CoreDataManager.manager.persistentContainer
        
        XCTAssertNotNil(container)
    }
    
    func test_create_house() {
        let powerSupply1: Int16 = 1300
        
        let house1 = coreDataManager.insertHouse(powerSupply: powerSupply1)
        XCTAssertNotNil(house1)
    }
    
    func test_fetch_house() {
        let house = coreDataManager.fetchHouse()!
        
        XCTAssertEqual(house.powerSupply, Int16(1300))
    }
    
    func test_update_house() {
        var house = coreDataManager.fetchHouse()!
        
        coreDataManager.updateHouse(to: Int16(2200), for: house)
        
        house = coreDataManager.fetchHouse()!
        
        XCTAssertEqual(house.powerSupply, Int16(2200))
    }

    func test_create_appliances() {
        let category = "Air Conditioner"
        let type = "1/2 PK"
        let power = Int16(400)
        let name = "AC Living Room"
        let quantity = Int16(1)
        let duration = Int32(18000)
        let repeatDay = ["SUN", "MON"]
        
        let appliance1 = coreDataManager.insertAppliance(name: name, category: category, type: type, power: power, quantity: quantity, duration: duration, repeatDay: repeatDay)
        
        XCTAssertEqual(appliance1?.category, category)
        XCTAssertEqual(appliance1?.type, type)
        XCTAssertEqual(appliance1?.power, power)
        XCTAssertEqual(appliance1?.repeatDay, repeatDay)
    }
    
    func test_update_appliance() {
        var appliance = coreDataManager.fetchAppliances()[0]
        
        let category = "Updated Appliance"
        let type = "1 PK"
        let power = appliance.power
        let name = appliance.name
        let quantity = appliance.quantity
        let duration = appliance.duration
        let repeatDay = ["MON", "TUE"]
        let conserve = false
        
        coreDataManager.updateAppliance(appliance: appliance, name: name!, category: category, type: type, power: power, quantity: quantity, duration: duration, repeatDay: repeatDay, conserve: conserve)
        
        appliance = coreDataManager.fetchAppliances()[0]
        XCTAssertEqual(appliance.name, name)
        XCTAssertEqual(appliance.type, type)
        XCTAssertEqual(appliance.conserve, conserve)
    }
}
