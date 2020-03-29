//
//  ChannelsViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import Firebase

class ChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ProfileDataManagerDelegate, ChannelsDataManagerDelegate  {
    
    @IBOutlet var channelsTableView: UITableView!
    @IBOutlet weak var newChannelTextField: UITextField!
    @IBOutlet weak var newChannelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    private let refreshControl = UIRefreshControl()
    
    private var isProfileDidReaded = false
    private var isChannelsDidLoaded = false

    private let profileDataManager = GCDProfileDataManager()
    private let channelsDataManager = FirestoreChannelsDataManager()
    private var channels: [String: ChannelModel] = [:]
    private var sectionsOfChannels = [SectionOfChannelsModel(name: "Online", channels: []),
                                      SectionOfChannelsModel(name: "History", channels: [])]
    
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
    
    @objc private func updateTableView() {
        for section in 0...sectionsOfChannels.count - 1 {
            sectionsOfChannels[section].channels = []
        }
        for channel in channels.values {
            let section = channel.isOnline ? 0 : 1
            sectionsOfChannels[section].channels.append(channel)
        }
        for section in 0...sectionsOfChannels.count - 1 {
            sectionsOfChannels[section].channels.sort(by: {channelFst, channelSnd in
                return !Utils.compareByDate(channelFst.lastActivity, channelSnd.lastActivity)
            })
        }
        channelsTableView.reloadData()
        channelsTableView.refreshControl?.endRefreshing()
        activityIndicator.stopAnimating()
        isChannelsDidLoaded = true
        tryShowTableView()
    }
    
    private func initTableView() {
        channelsTableView.alpha = 0
        channelsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
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
    
    private func startChannelsLoading() {
        channelsDataManager.startChannelsListener()
    }

    func channelsDifferenceDidLoaded(channelsDifference: [String: ChannelModel]) {
        for channel in channelsDifference.values {
            if let channelId = channel.identifier {
                channels[channelId] = channel
            }
        }
        updateTableView()
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
        startChannelsLoading()
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsOfChannels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsOfChannels[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsOfChannels[section].channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ChannelCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChannelCell else { return UITableViewCell() }
        let model = sectionsOfChannels[indexPath.section].channels[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let messagesStoryboard = UIStoryboard(name: "Messages", bundle: nil)
        if let messagesViewController = messagesStoryboard.instantiateInitialViewController() as? MessagesViewController {
            let model = sectionsOfChannels[indexPath.section].channels[indexPath.row]
            messagesViewController.setChannel(channel: model)
            messagesViewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(messagesViewController, animated: true)
        }
    }
}
