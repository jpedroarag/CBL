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
        return getPersistentContainer()
        }()!
    
    func getPersistentContainer(projectName name: String = "CBL") -> NSPersistentContainer? {
        return NSPersistentContainer(name: name)
    }
    
    func getContext(projectName name: String = "CBL") throws -> NSManagedObjectContext {
        let persistentContainer: NSPersistentContainer? = getPersistentContainer(projectName: name)
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
