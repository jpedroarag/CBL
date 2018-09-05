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
    
    func test_persistentStoresLoadErrorLocalized() {
        XCTAssertEqual(CoreDataManagerError.persistentStoresLoadError.localizedDescription, "Error while loading persistent stores")
    }
    
    func test_nilContainerLocalized() {
        XCTAssertEqual(CoreDataManagerError.nilContainer.localizedDescription, "Persistent container is nil")
    }
    
}
