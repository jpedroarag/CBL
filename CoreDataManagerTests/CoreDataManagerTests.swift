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
    
    func test_nilContainerLocalized() {
        XCTAssertEqual(CoreDataManager.CoreDataManagerErrors.nilContainer.localizedDescription, "Persistent container is nil")
    }
    
    func test_invalidContextForName() {
        XCTAssertEqual(CoreDataManager.CoreDataManagerErrors.invalidContextForName.localizedDescription, "Invalid context for given name")
    }
    
    func test_persistentContainer_success() {
        XCTAssertNotNil(coreData.newPersistentContainer())
    }

    func test_persistentContainer_fail() {
        XCTAssertNil(coreData.newPersistentContainer(projectName: "Erro induzido"))
    }
    
    func test_getContext_success() {
        XCTAssertEqual(coreData.persistentContainer?.viewContext, try coreData.getContext())
    }
    
    func test_getContext_fail() {
        XCTAssertThrowsError(try coreData.getContext(projectName: "Erro induzido"))
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
}
