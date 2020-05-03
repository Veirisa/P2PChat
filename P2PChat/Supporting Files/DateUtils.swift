//
//  DateUtils.swift
//  P2PChat
//
//  Created by Anna Rodionova on 22.03.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class DateUtils {
    
    static let recentlyInterval = 10 * 60
    
    static func isRecentlyDate(_ date: Date?, deviation: Int) -> Bool {
        guard let date = date else { return false }
        let currentTime = Date().timeIntervalSince1970
        let channelTime = date.timeIntervalSince1970
        return Int(currentTime - channelTime) < recentlyInterval + deviation
    }
    
    static func isRecentlyDate(_ date: Date?) -> Bool {
        return isRecentlyDate(date, deviation: 0)
    }
    
    static func handleDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
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
    }
    
    static func compareByDate(_ dateFst: Date?, _ dateSnd: Date?) -> Bool {
        guard let dateSnd = dateSnd else { return false }
        guard let dateFst = dateFst else { return true }
        return dateFst.timeIntervalSince1970 < dateSnd.timeIntervalSince1970
    }
}
