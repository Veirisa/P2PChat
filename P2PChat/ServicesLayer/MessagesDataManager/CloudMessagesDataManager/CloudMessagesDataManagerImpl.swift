//
//  CloudMessagesDataManagerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

class CloudMessagesDataManagerImpl: CloudMessagesDataManager {
    
    weak var delegate: CloudMessagesDataManagerDelegate?
    
    let channelId: String

    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    
    private var messagesListener: ListenerRegistration?
    
    required init(for channelId: String) {
        self.channelId = channelId
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    func addNew(message: MessageModel) {
        let messagesReference = channelsReference.document(channelId).collection("messages")
        messagesReference.addDocument(data: message.toDict)
    }
    
    func startMessagesListener() {
        let messagesReference = channelsReference.document(channelId).collection("messages")
        messagesListener = messagesReference.addSnapshotListener({[weak self] snapshot, error in
            if let error = error {
                print("Error loading messages: \(error)")
            } else {
                var addedMessagesDifference: [MessageModel] = []
                if let snapshot = snapshot {
                    for difference in snapshot.documentChanges {
                        if (difference.type == .added) {
                            if let message = parseMessageDict(from: difference.document.data()) {
                                addedMessagesDifference.append(message)
                            }
                        }
                    }
                }
                self?.delegate?.messagesDifferenceDidLoaded(added: addedMessagesDifference)
            }
        })
    }
}
