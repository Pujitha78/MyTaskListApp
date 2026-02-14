//
//  Persistence.swift
//  MyTaskListApp
//
//  Created by Pujitha Kadiyala on 2/14/26.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let viewContext: NSManagedObjectContext
    private let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "myTaskApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        viewContext = container.viewContext
    }
}
