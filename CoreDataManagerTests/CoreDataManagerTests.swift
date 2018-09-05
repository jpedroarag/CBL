//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
import CoreData
@testable import CBL

class CoreDataManagerTests: XCTestCase {
    
    var coreData: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager.shared
        coreData.resetSingleton()
    }
    
    func test_persistentContainer_success() {
        XCTAssertNoThrow(try coreData.newPersistentContainer())
    }

    func test_persistentContainer_fail() {
        XCTAssertNotEqual(NSPersistentContainer(name: "Erro induzido"), try? coreData.newPersistentContainer())
    }
    
    func test_getContext_success() {
        XCTAssertEqual(coreData.persistentContainer?.viewContext, try? coreData.getContext())
    }
    
    func test_getContext_fail() {
        coreData.persistentContainer = nil
        XCTAssertThrowsError(try coreData.getContext())
    }
    
    func test_saveContext_success() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "EssentialQuestion", in: context)
        let _ = EssentialQuestion(entity: entityDescription!, insertInto: context)
        coreData.saveContext()
        XCTAssertFalse(context.hasChanges)
    }
    
    func test_saveContext_fail() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "EssentialQuestion", in: context)
        let _ = EssentialQuestion(entity: entityDescription!, insertInto: context)
        
        coreData.persistentContainer = nil
        coreData.saveContext()
        
        let postContext = try? coreData.getContext()
        XCTAssertNil(postContext)
    }
    
    func test_deleteObject_success() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "EssentialQuestion", in: context)
        let obj = EssentialQuestion(entity: entityDescription!, insertInto: context)
        coreData.deleteObject(obj)
        
        XCTAssertFalse(context.hasChanges)
    }
    
    func test_deleteObject_fail() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "EssentialQuestion", in: context)
        let obj = EssentialQuestion(entity: entityDescription!, insertInto: context)
        
        coreData.persistentContainer = nil
        coreData.deleteObject(obj)
        
        let postContext = try? coreData.getContext()
        XCTAssertNil(postContext)
    }
    
    func test_deleteDataFrom_success() {
        coreData.deleteDataFrom(entity: "EssentialQuestion")
        XCTAssertFalse(try! coreData.getContext().hasChanges)
    }
    
    func test_deleteDataFrom_fail() {
        coreData.persistentContainer = nil
        coreData.deleteDataFrom(entity: "EssentialQuestion")
        
        let postContext = try? coreData.getContext()
        XCTAssertNil(postContext)
    }
    
    func test_getObjects_success() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "CBL", in: context)
        let _ = EssentialQuestion(entity: entityDescription!, insertInto: context)
        let result = coreData.getObjects(forEntity: "CBL")
        
        XCTAssertTrue(result.count > 0)
    }
    
    func test_getObjects_fail() {
        let context = try! coreData.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "CBL", in: context)
        let _ = CBL(entity: entityDescription!, insertInto: context)
        
        coreData.persistentContainer = nil
        
        let result = coreData.getObjects(forEntity: "CBL")
        XCTAssertEqual(result.count, 0)
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
}
