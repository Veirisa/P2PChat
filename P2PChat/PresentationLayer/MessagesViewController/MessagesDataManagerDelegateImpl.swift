//
//  MessagesDataManagerDelegateImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 12.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class MessagesDataManagerDelegateImpl: NSObject, MessagesDataManagerDelegate {
    
    private let messagesTableView: UITableView

    init(tableView: UITableView) {
        self.messagesTableView = tableView
    }
    
    private func scrollToBottom() {
        let messagesCount = messagesTableView.numberOfRows(inSection: 0)
        if messagesCount == 0 { return }
        let indexPath = IndexPath(row: messagesCount - 1, section: 0)
        messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
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
