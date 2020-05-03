//
//  ChannelsHandler.swift
//  P2PChat
//
//  Created by Anna Rodionova on 03.05.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol ChannelsHandler: class {

    func sortAndSplit(_ channels: [ChannelModel]) -> ChatModel
}
