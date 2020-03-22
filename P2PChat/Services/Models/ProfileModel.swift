//
//  ProfileModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 21.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class ProfileModel {
    let identifier = "anna_rodionova"
    var fullName = "-"
    var description = "-"
    var avatar = UIImage(named: "PlaceholderUser")
    
    static var shared: ProfileModel = {
           return ProfileModel()
    }()
    
    private init() {}
}

extension ProfileModel: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
