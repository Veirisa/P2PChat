//
//  MessagesDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesDataManager: class {
    
    init(for channelId: String)

    func addNew(message: MessageModel)
    func startMessagesListener()
    
    func loadMessagesFromCache() -> NSFetchedResultsController<StorageMessageModel>
}
