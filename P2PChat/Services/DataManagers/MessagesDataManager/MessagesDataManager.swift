//
//  MessagesDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol MessagesDataManager: class {
    
    func addNew(message: MessageModel, to channelId: String)
    func startMessagesListener(for channelId: String)
}
