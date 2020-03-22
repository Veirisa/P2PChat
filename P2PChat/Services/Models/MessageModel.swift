//
//  MessageModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 20.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

struct MessageModel {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension MessageModel {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
    }
    
    var isOutgoing: Bool {
        return senderId == ProfileModel.shared.identifier
    }
}

func parseMessageDict(from messageDict: [String: Any]) -> MessageModel? {
    guard
        let content = messageDict["content"] as? String,
        let created = messageDict["created"] as? Timestamp,
        let senderId = messageDict["senderID"] as? String,
        let senderName = messageDict["senderName"] as? String
        else { return nil }
    return MessageModel(content: content,
                        created: created.dateValue(),
                        senderId: senderId,
                        senderName: senderName)
}
