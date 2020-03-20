//
//  DataManagerDelegate.swift
//  P2PChat
//
//  Created by Anna Rodionova on 15.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol ProfileDataManagerDelegate: class {
    
    func didReadData(fullName: String?)
    func didReadData(description: String?)
    func didReadData(avatar: UIImage?)
    
    func didWriteData(fullName: String, status: Bool)
    func didWriteData(description: String, status: Bool)
    func didWriteData(avatar: UIImage, status: Bool)
}
