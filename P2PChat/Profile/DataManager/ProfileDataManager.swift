//
//  ProfileDataManager.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol ProfileDataManager: class {
    
    func readFullName()
    func readDescription()
    func readImage()
    
    func writeData(fullName: String)
    func writeData(description: String)
    func writeData(avatar: UIImage) 
}
