//
//  ChannelModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 20.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

struct ChannelModel {
    let identifier: String?
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension ChannelModel {
    var toDict: [String: Any] {
        return ["name": self.name]
    }
}

func parseChannelDict(from channelDict: [String: Any], identifier: String) -> ChannelModel? {
    guard
        let name = channelDict["name"] as? String,
        let lastMessage = channelDict["lastMessage"] as? String?,
        let lastActivity = channelDict["lastActivity"] as? Timestamp?
        else { return nil }
    return ChannelModel(identifier: identifier,
                        name: name,
                        lastMessage: lastMessage,
                        lastActivity: lastActivity?.dateValue())
}
