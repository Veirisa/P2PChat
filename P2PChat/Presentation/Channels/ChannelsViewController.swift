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

class ChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ProfileDataManagerDelegate, ChannelsDataManagerDelegate  {
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        initNavigationBar()
        initTableView()
        profileDataManager.delegate = self
        channelsDataManager.delegate = self
        readProfile()
        loadChannels()
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
    
    // MARK: Fetched Results Controller
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.channelsTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.channelsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    self.channelsTableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    guard let storageChannel = controller.object(at: indexPath) as? StorageChannelModel else { return }
                    guard let cell = self.channelsTableView.cellForRow(at: indexPath) as? ChannelCell else { return }
                    cell.configure(with: storageChannel)
                }
            case .move:
                if let indexPath = indexPath {
                    self.channelsTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                if let newIndexPath = newIndexPath {
                    self.channelsTableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.channelsTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            @unknown default: break
            }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelsTableView.endUpdates()
    }
}
