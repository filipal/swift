//
//  PersistenceController.swift
//  InOut Tracker
//
//  Created by Nives on 21.12.2024..
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "UserModel") // Zamijenite 'UserModel' nazivom vašeg Core Data modela
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }
}
