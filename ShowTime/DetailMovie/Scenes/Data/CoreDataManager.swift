//
//  CoreDataManager.swift
//  ShowTime
//
//  Created by MaurZac on 22/07/24.
//
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieModel") // Nombre del archivo .xcdatamodeld
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save Context
    func saveContext() {
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
}

