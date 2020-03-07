//
//  ConversationListViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ConversationListViewController: UITableViewController  {
    
    @IBOutlet var chatTableView: UITableView!
    
    private var onlineConversationList: [ConversationCellModel] = []
    private var historyConversationList: [ConversationCellModel] = []
    private var conversationList: [(String, [ConversationCellModel])] = []
    
    // MARK: Set data
    
    private func setData() {
        let today = Date()
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today)
        onlineConversationList = []
        onlineConversationList.append(contentsOf: Array(repeating: ConversationCellModel(name: "Best friend", message: "How are you?", date: today, isOnline: true, hasUnreadMessages: true), count: 5))
        onlineConversationList.append(contentsOf: Array(repeating: ConversationCellModel(name: "Friend", message: "Hello!", date: dayAgo, isOnline: true, hasUnreadMessages: false), count: 5))
        historyConversationList = []
        historyConversationList.append(contentsOf: Array(repeating: ConversationCellModel(name: "Former friend", message: "Goodbye!", date: yearAgo, isOnline: false, hasUnreadMessages: true), count: 5))
        historyConversationList.append(contentsOf: Array(repeating: ConversationCellModel(name: "Familiar", message: nil, date: nil, isOnline: false, hasUnreadMessages: false), count: 5))
        conversationList = [("Online", onlineConversationList), ("History", historyConversationList)]
    }
    
    // MARK: Update navigation bar

    @objc private func openProfile() {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        if let profileViewController = profileStoryboard.instantiateInitialViewController() {
            profileViewController.modalPresentationStyle = .fullScreen
            present(profileViewController, animated: true, completion: nil)
        }
    }
    
    private func updateNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(openProfile))
    }
    
    // MARK: Update table view
    
    private func updateTableView() {
        let identifier = String(describing: ConversationCell.self)
        chatTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: identifier)
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 67
        chatTableView.reloadData()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        updateNavigationBar()
        updateTableView()
    }
    
    // MARK: Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return conversationList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversationList[section].0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationList[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return UITableViewCell() }
        let model = (conversationList[indexPath.section].1)[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        if let conversationViewController = conversationStoryboard.instantiateInitialViewController() as? ConversationViewController {
            let model = (conversationList[indexPath.section].1)[indexPath.row]
            conversationViewController.setModel(model: model)
            conversationViewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}
