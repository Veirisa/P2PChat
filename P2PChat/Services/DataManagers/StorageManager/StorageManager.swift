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
    func performBackgroundTask(task: @escaping ((NSManagedObjectContext) -> Void))
}
