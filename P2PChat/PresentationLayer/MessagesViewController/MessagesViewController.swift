//
//  MessagesViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageTextView: UITextView!
    @IBOutlet weak var newMessageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var channel: StorageChannelModel?
    private var messagesDataManager: MessagesDataManager?
    private var messagesController: NSFetchedResultsController<StorageMessageModel>?
    private var messagesDataManagerDelegate: MessagesDataManagerDelegate?
    
    // MARK: Set model
    
    func setChannel(channel: StorageChannelModel) {
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
    
    private func updateTableView() {
        messagesTableView.reloadData()
        showTableView()
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
            let messageContent = newMessageTextView.text,
            let messagesDataManager = messagesDataManager
            else { return }
        if messageContent != ""{
            let profile = ProfileModel.shared
            messagesDataManager.addNew(message: MessageModel(content: messageContent, created: Date(), senderId: profile.identifier, senderName: profile.fullName))
            newMessageTextView.text = ""
        }
    }
    
    private func loadMessages() {
        messagesController = messagesDataManager?.loadMessagesFromCache()
        updateTableView()
        messagesDataManager?.startMessagesListener()
    }
    
    // MARK: Set data manager
      
    private func setDataManager() {
        if let channelId = channel?.identifier {
            let messagesDataManager = MessagesDataManagerImpl(for: channelId)
            messagesDataManagerDelegate = MessagesDataManagerDelegateImpl(tableView: messagesTableView)
            messagesDataManager.delegate = messagesDataManagerDelegate
            self.messagesDataManager = messagesDataManager
        }
    }
    
    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        initNavigationBar()
        initTableView()
        setDataManager()
        setLayoutCharacteristic()
        loadMessages()

    }
    
    // MARK: Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messagesController = messagesController else { return 0 }
        if let sections = messagesController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messagesController = messagesController else { return UITableViewCell() }
        let storageMessage = messagesController.object(at: indexPath)
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        cell.configure(with: storageMessage)
        return cell
    }
}
