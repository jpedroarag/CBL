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
    
    private override init() {}
    
    func resetSingleton() {
        CoreDataManager.shared = CoreDataManager()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer? = {
        let container = try? newPersistentContainer()
        return container
    }()
    
    func newPersistentContainer(projectName name: String = "CBL") throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        var persistentStoresError = false
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if (error as NSError?) != nil { persistentStoresError = true }
        })
        
        if persistentStoresError { throw CoreDataManagerError.persistentStoresLoadError }
        
        return container
    }
    
    // MARK: - View Context of Persistent Container
    func getContext() throws -> NSManagedObjectContext {
        if persistentContainer == nil { throw CoreDataManagerError.nilContainer }
        return persistentContainer!.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext (_ givenContext: NSManagedObjectContext? = nil) {
        do {
            var context = givenContext
            if context == nil { context = try getContext() }
            if (context?.hasChanges)! {
                try context?.save()
            }
        } catch let error as NSError {
            print("Error saving context. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data Delete support
    func deleteObject(_ object: NSManagedObject) {
        do {
            let context = try getContext()
            context.delete(object)
            try context.save()
        } catch let error as NSError {
            print("Error deleting object. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Core Data Delete All support
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
    
    // MARK: - Core Data Fetch support
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
