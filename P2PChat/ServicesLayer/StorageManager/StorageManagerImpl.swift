//
//  StorageManagerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 29.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class StorageManagerImpl: StorageManager {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "P2PChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure(error.localizedDescription)
            }
        })
        return container
    }()
    
    func fetchedResultsController<T>(fetchRequestTemp: NSFetchRequest<T>, keyForSort: String, ascending: Bool, sectionNameKeyPath: String?, sectionAscending: Bool?) -> NSFetchedResultsController<T> where T : NSFetchRequestResult {
        let fetchRequest = fetchRequestTemp
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: ascending)
        if let sectionNameKeyPath = sectionNameKeyPath, let sectionAscending = sectionAscending {
            let sectionSortDescriptor = NSSortDescriptor(key: sectionNameKeyPath, ascending: sectionAscending)
            fetchRequest.sortDescriptors = [sectionSortDescriptor, sortDescriptor]
        } else {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: persistentContainer.viewContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: nil)
    }
    
    func performMainTask(task: @escaping ((NSManagedObjectContext) -> Void)) {
        persistentContainer.viewContext.perform({[weak self] () -> Void in
            guard let self = self else { return }
            task(self.persistentContainer.viewContext)
        })
    }
    
    func performBackgroundTask(task: @escaping ((NSManagedObjectContext) -> Void)) {
        persistentContainer.performBackgroundTask(task);
    }
    
}
