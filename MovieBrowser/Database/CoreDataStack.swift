//
//  CoreDataStack.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation
import CoreData

protocol CoreDataStack {
    var managedContext: NSManagedObjectContext { get }
    func saveContext()
}

class AppCoreDataStack: CoreDataStack {
        
    static let shared = AppCoreDataStack()
    let modelName: String
    
    private init() {
        self.modelName = "MovieBrowser"
    }

    lazy var managedContext: NSManagedObjectContext = {
      return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
