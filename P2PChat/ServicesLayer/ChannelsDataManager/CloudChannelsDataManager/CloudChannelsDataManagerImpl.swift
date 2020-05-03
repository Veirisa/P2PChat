//
//  CloudChannelsDataManagerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

class CloudChannelsDataManagerImpl: CloudChannelsDataManager {
    
    weak var delegate: CloudChannelsDataManagerDelegate?

    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private var channelsListener: ListenerRegistration?
    
    deinit {
        channelsListener?.remove()
    }
    
    func addNew(channel: ChannelModel) {
        channelsReference.addDocument(data: channel.toDict)
    }
    
    func removeChannel(with channelId: String) {
        channelsReference.document(channelId).delete()
    }
    
    func startChannelsListener() {
        channelsListener = channelsReference.addSnapshotListener({[weak self] snapshot, error in
            if let error = error {
                print("Error loading channels: \(error)")
            } else {
                var addedChannelsDifference: [ChannelModel] = []
                var modifiedChannelsDifference: [ChannelModel] = []
                var removedChannelsDifference: [ChannelModel] = []
                if let snapshot = snapshot {
                    for difference in snapshot.documentChanges {
                        let channelId = difference.document.documentID
                        if let channel = parseChannelDict(from: difference.document.data(), identifier: channelId) {
                            switch difference.type {
                            case .added:
                                addedChannelsDifference.append(channel)
                            case .modified:
                                modifiedChannelsDifference.append(channel)
                            case .removed:
                                removedChannelsDifference.append(channel)
                            }
                        }
                    }
                }
                self?.delegate?.channelsDifferenceDidLoaded(added: addedChannelsDifference,
                                                            modified: modifiedChannelsDifference,
                                                            removed: removedChannelsDifference)
            }
        })
    }
}
