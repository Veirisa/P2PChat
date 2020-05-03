//
//  ProfileModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit
import CoreData

class ProfileModel {
    
    let identifier = "anna_rodionova"
    var fullName = "-"
    var description = "-"
    var avatar = UIImage(named: "PlaceholderUser")
    
    static var shared: ProfileModel = {
           return ProfileModel()
    }()
    
    private init() {}
    
    func update(profileStorage: StorageProfileModel) {
        if let fullName = profileStorage.fullName {
            self.fullName = fullName
        }
        if let description = profileStorage.userDescription {
            self.description = description
        }
        if let avatar = profileStorage.avatar {
            self.avatar = UIImage(data: avatar)
        }
    }
}

extension ProfileModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
