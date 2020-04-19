//
//  MessagesDataManagerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class MessagesDataManagerImpl: MessagesDataManager, CloudMessagesDataManagerDelegate {
    
    weak var delegate: MessagesDataManagerDelegate?
    
    private let channelId: String
    
    private var isCacheCleared = false
    
    private var cloudDataManager: CloudMessagesDataManager?
    private var storageManager: StorageManager = StorageManagerImpl()
    
    required init(for channelId: String) {
        self.channelId = channelId
    }
    
    private func messagesFetchRequest() -> NSFetchRequest<StorageMessageModel> {
        let fetchRequest = NSFetchRequest<StorageMessageModel>(entityName: "Message")
        fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", argumentArray: [channelId])
        return fetchRequest
    }
    
    // MARK: Cloud manage data
    
    func addNew(message: MessageModel) {
        trySetCloudDataManager()
        cloudDataManager?.addNew(message: message)
    }
    
    func startMessagesListener() {
        trySetCloudDataManager()
        cloudDataManager?.startMessagesListener()
    }
    
    private func trySetCloudDataManager() {
        if cloudDataManager == nil {
            let cloudDataManagerImpl = CloudMessagesDataManagerImpl(for: channelId)
            cloudDataManagerImpl.delegate = self
            cloudDataManager = cloudDataManagerImpl
        }
    }
    
    // MARK: Storage manage data (initial cache)
    
    func loadMessagesFromCache() -> NSFetchedResultsController<StorageMessageModel> {
        let controller: NSFetchedResultsController<StorageMessageModel> = storageManager.fetchedResultsController(fetchRequestTemp: messagesFetchRequest(), keyForSort: "created", ascending: true, sectionNameKeyPath: nil, sectionAscending: nil)
        controller.delegate = delegate
        try? controller.performFetch()
        return controller
    }
    
    // MARK: Storage manage data (runtime cache)
    
    func messagesDifferenceDidLoaded(added addedMessages: [MessageModel]) {
        let task = { [weak self] (context: NSManagedObjectContext) -> Void in
            guard let self = self else { return }
            if !self.isCacheCleared {
                let fetchRequest = self.messagesFetchRequest()
                let channelStorages = try? context.fetch(fetchRequest)
                if let channelStorages = channelStorages {
                    for channelStorage in channelStorages {
                          context.delete(channelStorage)
                    }
                }
                self.isCacheCleared = true
            }
            let fetchRequest = NSFetchRequest<StorageChannelModel>(entityName: "Channel")
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", argumentArray: [self.channelId])
            let channelStorages = try? context.fetch(fetchRequest)
            if let channelStorages = channelStorages {
                for channelStorage in channelStorages {
                    for message in addedMessages {
                        let messageStorage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? StorageMessageModel
                        if let messageStorage = messageStorage {
                            messageStorage.content = message.content
                            messageStorage.created = message.created
                            messageStorage.senderId = message.senderId
                            messageStorage.senderName = message.senderName
                            messageStorage.channel = channelStorage
                        }
                    }
                }
            }
            try? context.save()
        }
        storageManager.performMainTask(task: task)
    }
}
