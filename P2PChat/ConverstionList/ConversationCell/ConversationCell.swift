//
//  ConversationCell.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let messageFontSize = CGFloat(14)
    private let onlineUserColor = UIColor(red: 195.0 / 255, green: 190.0 / 255, blue: 153.0 / 255, alpha: 0.2)
    private let offlineUserColor = UIColor.clear
    
    private func updateName(with name: String) {
        nameLabel.text = name
    }
    
    private func updateMessage(with message: String?) {
        if let message = message {
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: messageFontSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageFontSize)
        }
    }
    
    private func updateDate(with date: Date?) {
        if let date = date {
            let format = DateFormatter()
            format.dateFormat = "yyyy"
            let yearString = format.string(from: date)
            if yearString != format.string(from: Date()) {
                format.dateFormat = "dd.MM.yyyy"
                dateLabel.text = format.string(from: date)
                return
            }
            format.dateFormat = "dd.MM"
            let dayMonthString = format.string(from: date)
            if dayMonthString != format.string(from: Date()) {
                dateLabel.text = dayMonthString
                return
            }
            format.dateFormat = "HH:mm"
            dateLabel.text = format.string(from: date)
        } else {
            dateLabel.text = ""
        }
    }
    
    private func updateIsOnline(with isOnline: Bool) {
        if isOnline {
            backgroundColor = onlineUserColor
        } else {
            backgroundColor = offlineUserColor
        }
    }
    
    private func updateHasUnreadMessage(with hasUnreadMessage: Bool) {
        if hasUnreadMessage {
            messageLabel.font = UIFont.boldSystemFont(ofSize: messageFontSize)
        }
        // In another case - correct font was setted in updateMessage.
    }
    
    func configure(with model: ConversationCellModel) {
        updateName(with: model.name)
        updateMessage(with: model.message)
        updateDate(with: model.date)
        updateIsOnline(with: model.isOnline)
        updateHasUnreadMessage(with: model.hasUnreadMessages)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.textColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
