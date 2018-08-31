//
//  CoreDataError.swift
//  CBL
//
//  Created by Ada 2018 on 31/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

enum CoreDataManagerError : Error {
    case nilContainer
    case invalidContextForName
    case persistentStoresLoadError
    
    var localizedDescription : String {
        switch self {
        case .nilContainer:
            return "Persistent container is nil"
        case .invalidContextForName:
            return "Invalid context for given name"
        case .persistentStoresLoadError:
            return "Error while loading persistent stores"
        }
    }
}
