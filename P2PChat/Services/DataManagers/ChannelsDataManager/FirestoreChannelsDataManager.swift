//
//  FirestoreChannelsDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

class FirestoreChannelsDataManager: ChannelsDataManager {
    
    weak var delegate: ChannelsDataManagerDelegate?

    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private var channelsListener: ListenerRegistration?
    
    deinit {
        channelsListener?.remove()
    }
    
    func addNew(channel: ChannelModel) {
        channelsReference.addDocument(data: channel.toDict)
    }
    
    func startChannelsListener() {
        channelsListener = channelsReference.addSnapshotListener({[weak self] snapshot, error in
            if let error = error {
                print("Error loading channels: \(error)")
            } else {
                var channelsDifference: [String: ChannelModel] = [:]
                if let snapshot = snapshot {
                    for difference in snapshot.documentChanges {
                        if (difference.type == .added || difference.type == .modified) {
                            let channelId = difference.document.documentID
                            if let channel = parseChannelDict(from: difference.document.data(), identifier: channelId) {
                                channelsDifference[channelId] = channel
                            }
                        }
                    }
                }
                self?.delegate?.channelsDifferenceDidLoaded(channelsDifference: channelsDifference)
            }
        })
    }
}
