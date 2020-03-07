//
//  ConversationViewController.swift
//  P2PChat
//
//  Created by Анна Родионова on 01.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var newMessageView: UIView!
    @IBOutlet weak var newMessageLabel: UILabel!
    
    private var conversationModel: ConversationCellModel? = nil
    private var conversationMessageList: [MessageCellModel] = []
    
    // MARK: Set model
    
    func setModel(model: ConversationCellModel) {
        conversationModel = model
    }
    
    // MARK: Set data
    
    func setData() {
        conversationMessageList = []
        let incomingMessage = MessageCellModel(isIncoming: true, text: "Incoming message for you! Na na na na na na na na na na na na na na na na na na na na na na na na na na na na na na na.")
        let outgoingMessage = MessageCellModel(isIncoming: false, text:  "Outgoing message from me!")
        for _ in 1...10 {
            conversationMessageList.append(incomingMessage)
            conversationMessageList.append(outgoingMessage)
        }
    }
    
    // MARK: Update navigation bar
    
    private func updateNavigationBar() {
        navigationItem.title = conversationModel?.name
    }
    
    // MARK: Update table view
    
    private func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(row: self.conversationMessageList.count - 1, section: 0)
            self.conversationTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    private func updateTableView() {
        let identifier = String(describing: MessageCell.self)
        conversationTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: identifier)
        conversationTableView.rowHeight = UITableView.automaticDimension
        conversationTableView.reloadData()
        scrollToBottom()
    }
    
    // MARK: Set layout characteristics
    
    private func setLayoutCharacteristic() {
        newMessageView.layer.cornerRadius = 10
        newMessageView.clipsToBounds = true
        newMessageLabel.textColor = .darkGray
    }
    
    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        updateNavigationBar()
        updateTableView()
        setLayoutCharacteristic()
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationMessageList.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        let model = conversationMessageList[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
