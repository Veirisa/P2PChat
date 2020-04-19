//
//  StorageProfileDataManagerManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class ProfileDataManagerImpl: ProfileDataManager {
    
    weak var delegate: ProfileDataManagerDelegate?
    
    private var storageManager: StorageManager = StorageManagerImpl()
    
    // MARK: Reading
    
    func readProfile() {
        let task = { [weak self] (context: NSManagedObjectContext) -> Void in
            let fetchRequest = NSFetchRequest<StorageProfileModel>(entityName: "Profile")
            let allProfileStorages = try? context.fetch(fetchRequest)
            let profileStorage = allProfileStorages?.last
            if let profileStorage = profileStorage {
                let profile = ProfileModel.shared
                profile.update(profileStorage: profileStorage)
            }
            self?.delegate?.profileDidReaded()
        }
        storageManager.performBackgroundTask(task: task)
    }
    
    // MARK: Writing
    
    func writeProfile(fullName: String?, description: String?, avatar: UIImage?) {
        let task = { [weak self] (context: NSManagedObjectContext) -> Void in
            let profileStorage = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as? StorageProfileModel
            if let fullName = fullName {
                profileStorage?.fullName = fullName
            }
            if let description = description {
                profileStorage?.userDescription = description
            }
            if let avatar = avatar {
                profileStorage?.avatar = avatar.pngData()
            }
            do {
                try context.save()
                if let profileStorage = profileStorage {
                    let profile = ProfileModel.shared
                    profile.update(profileStorage: profileStorage)
                }
                self?.delegate?.profileDidWrited(status: true)
            } catch {
                self?.delegate?.profileDidWrited(status: false)
            }
        }
        storageManager.performBackgroundTask(task: task)
    }
}
