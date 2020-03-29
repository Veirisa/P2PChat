//
//  ProfileStorageModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 29.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

@objc(Profile)
class ProfileStorageModel: NSManagedObject {
    var fullName: String?
    var userDescription: String?
    var avatar: UIImage?
}
