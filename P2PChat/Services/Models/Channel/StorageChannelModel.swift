//
//  StorageChannelModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

@objc(Channel)
class StorageChannelModel: NSManagedObject {
    @NSManaged var identifier: String?
    @NSManaged var name: String
    @NSManaged var lastMessage: String?
    @NSManaged var lastActivity: Date?
    @NSManaged var messages: NSSet?
    @NSManaged var sectionName: String
    
    var isOnline: Bool {
        return DateUtils.isRecentlyDate(lastActivity)
    }
}
