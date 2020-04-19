//
//  StorageManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 29.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

protocol StorageManager: class {
    
    func fetchedResultsController<T>(fetchRequestTemp: NSFetchRequest<T>, keyForSort: String, ascending: Bool, sectionNameKeyPath: String?, sectionAscending: Bool?) -> NSFetchedResultsController<T>
    
    func performMainTask(task: @escaping ((NSManagedObjectContext) -> Void))
    func performBackgroundTask(task: @escaping ((NSManagedObjectContext) -> Void))
}
