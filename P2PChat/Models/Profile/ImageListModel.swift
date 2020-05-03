//
//  ImageListModel.swift
//  P2PChat
//
//  Created by Anna Rodionova on 19.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

struct ImageListModel: Codable {
    let images: [ImageDataModel]
    
    enum CodingKeys: String, CodingKey {
        case images = "hits"
    }
}
