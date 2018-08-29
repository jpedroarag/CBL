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
    public var projectName = "CBL"
    
    enum CoreDataManagerErrors : Error {
        case nilContainer
        
        var localizedDescription : String {
            switch self {
            case .nilContainer:
                return "Persistent Container is nil"
            }
        }
    }
    
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: projectName)
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
        return container
    }()
    
    func getContext() throws -> NSManagedObjectContext {
        let persistentContainer: NSPersistentContainer? = self.persistentContainer
        if persistentContainer == nil { throw CoreDataManagerErrors.nilContainer }
        return persistentContainer!.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteDataFrom(entity name: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try self.persistentContainer.viewContext.execute(request)
            try self.persistentContainer.viewContext.save()
        } catch {
            print("Error")
        }
    }
    
    func getObjects(forEntity name: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        var results = [NSManagedObject]()
        do {
            results = try self.persistentContainer.viewContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return results
    }
}
