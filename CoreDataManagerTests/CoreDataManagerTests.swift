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
    let projectName = (success: "CBL", fail: "Erro induzido")
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager.shared
    }
    
    func test_persistentContainer_success() {
        coreData.projectName = projectName.success
        let container = coreData.persistentContainer
        XCTAssertNotNil(container)
    }
    
    func test_persistentContainer_fail() {
        coreData.projectName = projectName.fail
        let container: NSPersistentContainer? = coreData.persistentContainer
        XCTAssertNil(container)
    }
    
    func test_getContext_success() {
        coreData.projectName = projectName.success
        XCTAssertEqual(coreData.persistentContainer.viewContext, try coreData.getContext())
    }
    
    func test_getContext_fail() {
        coreData.projectName = projectName.fail
        XCTAssertThrowsError(try coreData.getContext())
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
}
