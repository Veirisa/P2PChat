//
//  MessagesViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MessagesDataManagerDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageTextView: UITextView!
    @IBOutlet weak var newMessageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let messagesDataManager = FirestoreMessagesDataManager()
    private var channel: ChannelModel? = nil
    private var messages: [MessageModel] = []
    
    // MARK: Set model
    
    func setChannel(channel: ChannelModel) {
        self.channel = channel
    }
    
    // MARK: Init navigation bar
    
    private func initNavigationBar() {
        navigationItem.title = channel?.name
    }
    
    // MARK: Init table view
    
    private func showTableView() {
        messagesTableView.alpha = 1
        activityIndicator.stopAnimating()
    }
    
    private func scrollToBottom() {
        if messages.isEmpty { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func updateTableViewData() {
        messagesTableView.reloadData()
        scrollToBottom()
    }
    
    private func initTableView() {
        messagesTableView.alpha = 0
        let identifier = String(describing: MessageCell.self)
        messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: identifier)
        messagesTableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: Set layout characteristics
    
    private func setLayoutCharacteristic() {
        newMessageView.layer.cornerRadius = 10
        newMessageView.clipsToBounds = true
    }
    
    // MARK: Manage data
    
    @IBAction func addNewMessage(_ sender: UIButton) {
        guard
            let channelId = channel?.identifier,
            let messageContent = newMessageTextView.text
            else { return }
        if messageContent != ""{
            let profile = ProfileModel.shared
            messagesDataManager.addNew(message: MessageModel(content: messageContent, created: Date(), senderId: profile.identifier, senderName: profile.fullName), to: channelId)
            newMessageTextView.text = ""
        }
    }
    
    private func startMessagesLoading() {
        guard let channelId = channel?.identifier else { return }
        messagesDataManager.startMessagesListener(for: channelId)
    }
    
    func messagesDifferenceDidLoaded(messagesDifference: [MessageModel]) {
        var messagesDifference = messagesDifference
        messagesDifference.sort(by: {messageFst, messageSnd in
            return Utils.compareByDate(messageFst.created, messageSnd.created)
        })
        messages.append(contentsOf: messagesDifference)
        updateTableViewData()
        showTableView()
    }
    
    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        initNavigationBar()
        initTableView()
        setLayoutCharacteristic()
        messagesDataManager.delegate = self
        startMessagesLoading()
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        let model = messages[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
