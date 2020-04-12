//
//  ChannelCell.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let messageFontSize = CGFloat(14)
    private let onlineUserColor = UIColor(red: 195.0 / 255, green: 190.0 / 255, blue: 153.0 / 255, alpha: 0.2)
    private let offlineUserColor = UIColor.clear
    
    func configure(with model: StorageChannelModel) {
        nameLabel.text = model.name
        if let message = model.lastMessage {
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: messageFontSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageFontSize)
        }
        dateLabel.text = DateUtils.handleDate(model.lastActivity)
        if model.isOnline {
            backgroundColor = onlineUserColor
        } else {
            backgroundColor = offlineUserColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.textColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
