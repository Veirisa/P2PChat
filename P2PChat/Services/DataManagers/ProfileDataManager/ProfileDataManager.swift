//
//  ProfileDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol ProfileDataManager: class {
    
    func readProfile()
    func writeProfile(fullName: String?, description: String?, avatar: UIImage?)
}
