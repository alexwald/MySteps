//
//  PersistenceController.swift
//  MySteps
//
//  Created by alex on 03/05/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MySteps")
  
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //TODO: handle error properly
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
