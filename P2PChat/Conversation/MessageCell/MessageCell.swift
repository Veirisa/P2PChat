//
//  MessageCell.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leadingMessageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingMessageViewConstraint: NSLayoutConstraint!
    
    private let incomingColor = UIColor(red: 242.0 / 255, green: 242.0 / 255, blue: 247.0 / 255, alpha: 1)
    private let outgoingColor = UIColor(red: 201.0 / 255, green: 232.0 / 255, blue: 251.0 / 255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 10
        messageView.clipsToBounds = true
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        if model.isIncoming {
            trailingMessageViewConstraint.isActive = false
            leadingMessageViewConstraint.isActive = true
            messageView.backgroundColor = incomingColor
        } else {
            leadingMessageViewConstraint.isActive = false
            trailingMessageViewConstraint.isActive = true
            messageView.backgroundColor = outgoingColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
