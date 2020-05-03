//
//  ChannelsHandlerImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 03.05.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ChannelsHandlerImpl: ChannelsHandler {

    func sortAndSplit(_ channels: [ChannelModel]) -> ChatModel {
        var sortedChannels = channels
        sortedChannels.sort(by: {channelFst, channelSnd in
            return !DateUtils.compareByDate(channelFst.lastActivity, channelSnd.lastActivity)
        })
        var chat = ChatModel(onlineChannels: [], historyChannels: [])
        for channel in sortedChannels {
            if DateUtils.isRecentlyDate(channel.lastActivity) {
                chat.onlineChannels.append(channel)
            } else {
                chat.historyChannels.append(channel)
            }
        }
        return chat
    }
}
