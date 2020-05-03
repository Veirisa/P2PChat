//
//  StorageMessageModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

@objc(Message)
class StorageMessageModel: NSManagedObject {
    @NSManaged var content: String
    @NSManaged var created: Date
    @NSManaged var senderId: String
    @NSManaged var senderName: String
    @NSManaged var channel: StorageChannelModel?
    
    var isOutgoing: Bool {
        return senderId == ProfileModel.shared.identifier
    }
}
