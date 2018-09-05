//
//  ErrorsTests.swift
//  CBLTests
//
//  Created by Ada 2018 on 05/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import XCTest
@testable import CBL

class ErrorsTests: XCTestCase {
    
    func test_emptyTextFieldLocalized() {
        XCTAssertEqual(TextFieldError.emptyTextField.localizedDescription, "Question text field is empty!")
    }
    
}
