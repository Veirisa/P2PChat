//
//  StorageProfileModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 29.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

@objc(Profile)
class StorageProfileModel: NSManagedObject {
    @NSManaged var fullName: String?
    @NSManaged var userDescription: String?
    @NSManaged var avatar: Data?
}
