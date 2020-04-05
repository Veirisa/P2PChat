//
//  CoreDataStorageManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 29.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStorageManager: StorageManager {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "P2PChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure(error.localizedDescription)
            }
        })
        return container
    }()
 
    func performBackgroundTask(task: @escaping ((NSManagedObjectContext) -> Void)) {
        persistentContainer.performBackgroundTask(task);
    }
}
