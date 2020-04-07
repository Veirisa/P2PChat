//
//  ChannelsDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 06.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

protocol ChannelsDataManager: class {

    func addNew(channel: ChannelModel)
    func removeChannel(with channelId: String)
    func startChannelsListener()
    
    func loadChannelsFromCache() -> NSFetchedResultsController<StorageChannelModel>
}
