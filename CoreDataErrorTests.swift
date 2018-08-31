//
//  CoreDataErrorTests.swift
//  CBLTests
//
//  Created by Ada 2018 on 31/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import CBL

class CoreDataErrorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_nilContainerLocalized() {
        XCTAssertEqual(CoreDataManager.CoreDataManagerErrors.nilContainer.localizedDescription, "Persistent container is nil")
    }
    
    func test_invalidContextForNameLocalized() {
        XCTAssertEqual(CoreDataManager.CoreDataManagerErrors.invalidContextForName.localizedDescription, "Invalid context for given name")
    }
    
    func test_nilContainerLocalized() {
        XCTAssertEqual(CoreDataManager.CoreDataManagerErrors.nilContainer.localizedDescription, "Persistent container is nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
