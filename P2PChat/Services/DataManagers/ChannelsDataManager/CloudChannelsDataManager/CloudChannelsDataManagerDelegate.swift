//
//  CloudChannelsDataManagerDelegate.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol CloudChannelsDataManagerDelegate: class {
    
    func channelsDifferenceDidLoaded(added addedChannels: [ChannelModel],
                                     modified modifiedChannels: [ChannelModel],
                                     removed removedChannels: [ChannelModel])
}
