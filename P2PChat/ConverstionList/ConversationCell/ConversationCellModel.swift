//
//  ConversationCellModel.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
