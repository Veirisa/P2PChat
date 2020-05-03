//
//  ChannelsViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ChannelsViewController: P2PViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ProfileDataManagerDelegate  {
    
    @IBOutlet var channelsTableView: UITableView!
    @IBOutlet weak var newChannelTextField: UITextField!
    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    private let refreshControl = UIRefreshControl()
    
    private var isProfileDidReaded = false
    private var isChannelsDidLoaded = false

    private let profileDataManager = ProfileDataManagerImpl()
    private let channelsDataManager = ChannelsDataManagerImpl()
    
    private var channelsController: NSFetchedResultsController<StorageChannelModel>?
    private var channelsDataManagerDelegate: ChannelsDataManagerDelegate?
    
    // MARK: Init navigation bar

    @objc private func openProfile() {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        if let profileViewController = profileStoryboard.instantiateInitialViewController() {
            profileViewController.modalPresentationStyle = .fullScreen
            present(profileViewController, animated: true, completion: nil)
        }
    }
    
    private func initNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
    }
    
    // MARK: Init table view
    
    private func tryShowTableView() {
        if isProfileDidReaded && isChannelsDidLoaded {
            channelsTableView.alpha = 1
            activityIndicator.stopAnimating()
        }
    }
    
    private func updateTableView() {
        channelsTableView.reloadData()
        activityIndicator.stopAnimating()
        isChannelsDidLoaded = true
        tryShowTableView()
    }
    
    private func initTableView() {
        channelsTableView.alpha = 0

        let identifier = String(describing: ChannelCell.self)
        channelsTableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: identifier)
        channelsTableView.rowHeight = UITableView.automaticDimension
        channelsTableView.estimatedRowHeight = 67
    }
    
    // MARK: Manage data (profile)
    
    private func readProfile() {
        profileDataManager.readProfile()
    }
    
    func profileDidReaded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isProfileDidReaded = true
            self.tryShowTableView()
        }
    }
    
    func profileDidWrited(status: Bool) {}
    
    // MARK: Manage data (channels)
    
    @IBAction func addNewChannel(_ sender: UIButton) {
        guard let channelName = newChannelTextField.text else { return }
        if channelName != "" {
            channelsDataManager.addNew(channel: ChannelModel(identifier: nil, name: channelName, lastMessage: nil, lastActivity: nil))
            newChannelTextField.text = ""
        }
    }
    
    func removeChannel(with channelId: String) {
        channelsDataManager.removeChannel(with: channelId)
    }
    
    private func loadChannels() {
        channelsController = channelsDataManager.loadChannelsFromCache()
        updateTableView()
        channelsDataManager.startChannelsListener()
    }
    
    // MARK: Set data managers
    
    private func setDataManagers() {
        profileDataManager.delegate = self
        channelsDataManagerDelegate = ChannelsDataManagerDelegateImpl(tableView: channelsTableView)
        channelsDataManager.delegate = channelsDataManagerDelegate
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        initNavigationBar()
        initTableView()
        setDataManagers()
        readProfile()
        loadChannels()
    }
    
    // MARK: Text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let channelsController = channelsController else { return 0 }
        if let sections = channelsController.sections {
            return sections.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let channelsController = channelsController else { return nil }
        return channelsController.sections?[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channelsController = channelsController else { return 0 }
        if let sections = channelsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let channelsController = channelsController else { return UITableViewCell() }
        let storageChannel = channelsController.object(at: indexPath)
        let identifier = String(describing: ChannelCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChannelCell else { return UITableViewCell() }
        cell.configure(with: storageChannel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let channelsController = channelsController else { return }
        let messagesStoryboard = UIStoryboard(name: "Messages", bundle: nil)
        if let messagesViewController = messagesStoryboard.instantiateInitialViewController() as? MessagesViewController {
            let storageChannel = channelsController.object(at: indexPath)
            messagesViewController.setChannel(channel: storageChannel)
            messagesViewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(messagesViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            guard let self = self else { return }
            guard let channelsController = self.channelsController else { return }
            guard let channelId = channelsController.object(at: indexPath).identifier else { return }
            self.removeChannel(with: channelId)
        }
        return [deleteAction]
    }
}
