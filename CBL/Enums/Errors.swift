//
//  Errors.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

enum TextFieldError : Error {
    case emptyTextField
    
    var localizedDescription: String {
        switch self {
        case .emptyTextField:
            return "There is some empty text field"
        }
    }
}
