//
//  NetworkProfilePictureLoader.swift
//  P2PChat
//
//  Created by Anna Rodionova on 19.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

protocol NetworkProfilePictureLoader: class {
    
    func loadImageList(callback: @escaping (ImageListModel) -> Void)
    func loadImage(with url: String, callback: @escaping (UIImage) -> Void)
}
