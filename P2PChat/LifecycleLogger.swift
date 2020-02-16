//
//  LifecycleLogger.swift
//  P2PChat
//
//  Created by Анна Родионова on 16.02.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class LifecycleLogger {

    // you can enable or disable logging here
    private var isLogEnabled: Bool = true
    
    func log(with message: String) {
        if isLogEnabled {
            print(message)
        }
    }
}
