//
//  MessagesViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MessagesDataManagerDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageTextView: UITextView!
    @IBOutlet weak var newMessageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var channel: StorageChannelModel?
    private var messagesDataManager: MessagesDataManager?
    private var messagesController: NSFetchedResultsController<StorageMessageModel>?
    
    // MARK: Set model
    
    func setChannel(channel: StorageChannelModel) {
        self.channel = channel
        if let channelId = channel.identifier {
            let messagesDataManager = MessagesDataManagerImpl(for: channelId)
            messagesDataManager.delegate = self
            self.messagesDataManager = messagesDataManager
        }
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
        let messagesCount = tableView(messagesTableView, numberOfRowsInSection: 0)
        if messagesCount == 0 { return }
        let indexPath = IndexPath(row: messagesCount - 1, section: 0)
        messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func updateTableView() {
        messagesTableView.reloadData()
        scrollToBottom()
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

    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        initNavigationBar()
        initTableView()
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
    
    // MARK: Fetched Results Controller
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    self.messagesTableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    guard let storageMessage = controller.object(at: indexPath) as? StorageMessageModel else { return }
                    guard let cell = self.messagesTableView.cellForRow(at: indexPath) as? MessageCell else { return }
                    cell.configure(with: storageMessage)
                }
            case .move:
                if let indexPath = indexPath {
                    self.messagesTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                if let newIndexPath = newIndexPath {
                    self.messagesTableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.messagesTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            @unknown default: break
            }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTableView.endUpdates()
        scrollToBottom()
    }
}
