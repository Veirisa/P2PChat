//
//  ChannelsDataManagerDelegateImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 12.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class ChannelsDataManagerDelegateImpl: NSObject, ChannelsDataManagerDelegate {

    private let channelsTableView: UITableView
    
    init(tableView: UITableView) {
        self.channelsTableView = tableView
    }
    
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
