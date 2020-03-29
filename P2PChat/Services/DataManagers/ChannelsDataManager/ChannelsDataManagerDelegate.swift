//
//  ChannelsDataManagerDelegate.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol ChannelsDataManagerDelegate: class {
    
    func channelsDifferenceDidLoaded(channelsDifference: [String: ChannelModel])
}
