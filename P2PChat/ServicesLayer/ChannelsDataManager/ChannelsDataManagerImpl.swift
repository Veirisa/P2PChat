//
//  ChannelsDataManagerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class ChannelsDataManagerImpl: ChannelsDataManager, CloudChannelsDataManagerDelegate {
    
    weak var delegate: ChannelsDataManagerDelegate?
    
    private var isCacheCleared = false
    
    private var cloudDataManager: CloudChannelsDataManager?
    private var storageManager: StorageManager = StorageManagerImpl()
    
    private func channelsFetchRequest() -> NSFetchRequest<StorageChannelModel> {
        return NSFetchRequest<StorageChannelModel>(entityName: "Channel")
    }
    
    // MARK: Cloud manage data
    
    func addNew(channel: ChannelModel) {
        trySetCloudDataManager()
        cloudDataManager?.addNew(channel: channel)
    }
    
    func removeChannel(with channelId: String) {
        trySetCloudDataManager()
        cloudDataManager?.removeChannel(with: channelId)
    }
    
    func startChannelsListener() {
        trySetCloudDataManager()
        cloudDataManager?.startChannelsListener()
    }
    
    private func trySetCloudDataManager() {
        if cloudDataManager == nil {
            let cloudDataManagerImpl = CloudChannelsDataManagerImpl()
            cloudDataManagerImpl.delegate = self
            cloudDataManager = cloudDataManagerImpl
        }
    }
    
    // MARK: Storage manage data (initial cache)
    
    func loadChannelsFromCache() -> NSFetchedResultsController<StorageChannelModel> {
        let controller: NSFetchedResultsController<StorageChannelModel> =
            storageManager.fetchedResultsController(fetchRequestTemp: channelsFetchRequest(), keyForSort: "lastActivity", ascending: false, sectionNameKeyPath: "sectionName", sectionAscending: false)
        controller.delegate = delegate
        try? controller.performFetch()
        return controller
    }
    
    // MARK: Storage manage data (runtime cache)
    
    func channelsDifferenceDidLoaded(added addedChannels: [ChannelModel], modified modifiedChannels: [ChannelModel], removed removedChannels: [ChannelModel]) {
        let task = { [weak self] (context: NSManagedObjectContext) -> Void in
            guard let self = self else { return }
            if !self.isCacheCleared {
                let fetchRequest = self.channelsFetchRequest()
                let channelStorages = try? context.fetch(fetchRequest)
                if let channelStorages = channelStorages {
                    for channelStorage in channelStorages {
                          context.delete(channelStorage)
                    }
                }
                self.isCacheCleared = true
            }
            for channel in addedChannels {
                if let channelStorage = NSEntityDescription.insertNewObject(forEntityName: "Channel", into: context) as? StorageChannelModel {
                    channelStorage.identifier = channel.identifier
                    channelStorage.name = channel.name
                    channelStorage.lastMessage = channel.lastMessage
                    channelStorage.lastActivity = channel.lastActivity
                    channelStorage.sectionName = channelStorage.isOnline ? "Online" : "History"
                }
            }
            for channel in modifiedChannels {
                guard let channelId = channel.identifier else { continue }
                let fetchRequest = self.channelsFetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", argumentArray: [channelId])
                let channelStorages = try? context.fetch(fetchRequest)
                if let channelStorages = channelStorages {
                    for channelStorage in channelStorages {
                        channelStorage.lastMessage = channel.lastMessage
                        channelStorage.lastActivity = channel.lastActivity
                        channelStorage.sectionName = channelStorage.isOnline ? "Online" : "History"
                    }
                }
            }
            for channel in removedChannels {
                guard let channelId = channel.identifier else { continue }
                let fetchRequest = self.channelsFetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", argumentArray: [channelId])
                let channelStorages = try? context.fetch(fetchRequest)
                if let channelStorages = channelStorages {
                    for channelStorage in channelStorages {
                        context.delete(channelStorage)
                    }
                }
            }
            try? context.save()
        }
        storageManager.performMainTask(task: task)
    }
}
