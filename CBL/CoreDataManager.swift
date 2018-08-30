//
//  CoreDataManager.swift
//  CBL
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import CoreData

class CoreDataManager : NSObject {
    static var shared = CoreDataManager()
    
    enum CoreDataManagerErrors : Error {
        case nilContainer
        case invalidContextForName
        
        var localizedDescription : String {
            switch self {
            case .nilContainer:
                return "Persistent container is nil"
            case .invalidContextForName:
                return "Invalid context for given name"
            
            }
        }
    }
    
    private override init() {}
    
    func resetSingleton() {
        CoreDataManager.shared = CoreDataManager()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer? = {
        return newPersistentContainer()
    }()
    
    func newPersistentContainer(projectName name: String = "CBL") -> NSPersistentContainer? {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
    
    func getContext(projectName name: String = "CBL") throws -> NSManagedObjectContext {
        if name != "CBL" { throw CoreDataManagerErrors.invalidContextForName }
        return persistentContainer!.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        do {
            let context = try getContext()
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print("Error saving context. \(error), \(error.userInfo)")
        }
    }
    
    func deleteDataFrom(entity name: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            let context = try getContext()
            try context.execute(request)
            try context.save()
        } catch let error as NSError {
            print("Error deleting data. \(error), \(error.userInfo)")
        }
    }
    
    func getObjects(forEntity name: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        var results = [NSManagedObject]()
        do {
            let context = try getContext()
            results = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return results
    }
}
