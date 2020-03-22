//
//  Utils.swift
//  P2PChat
//
//  Created by Anna Rodionova on 22.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class Utils {
    
    static func handleDate(_ date: Date?) -> String {
        if let date = date {
            let format = DateFormatter()
            format.dateFormat = "yyyy"
            let yearString = format.string(from: date)
            if yearString != format.string(from: Date()) {
                format.dateFormat = "dd.MM.yyyy"
                return format.string(from: date)
            }
            format.dateFormat = "dd.MM"
            let dayMonthString = format.string(from: date)
            if dayMonthString != format.string(from: Date()) {
                return dayMonthString
            }
            format.dateFormat = "HH:mm"
            return format.string(from: date)
        } else {
            return ""
        }
    }
    
    static func compareByDate(_ dateFst: Date?, _ dateSnd: Date?) -> Bool {
        guard let dateFst = dateFst else { return true }
        guard let dateSnd = dateSnd else { return false }
        return dateFst.timeIntervalSince1970 < dateSnd.timeIntervalSince1970
    }
}
