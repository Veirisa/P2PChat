//
//  ChannelsHandlerTests.swift
//  P2PChatTests
//
//  Created by Anna Rodionova on 03.05.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import XCTest
@testable import P2PChat

class ChannelsHandlerTests: XCTestCase {

    private let minuteTimeInterval = 360
    private let currentDate = Date()
    
    private var channels: [ChannelModel] = []
    
    private var channelsSorter: ChannelsHandler!

    override func setUp() {
        self.channelsSorter = ChannelsHandlerImpl()
        
        for i in 0 ..< 5 {
            channels.append(
                ChannelModel(identifier: nil,
                             name: "",
                             lastMessage: nil,
                             lastActivity: currentDate.addingTimeInterval(TimeInterval(-i * minuteTimeInterval)))
            )
        }
        for i in 5 ..< 15 {
            let duplicateTimeChannel =
                ChannelModel(identifier: nil,
                             name: "",
                             lastMessage: nil,
                             lastActivity: currentDate.addingTimeInterval(TimeInterval(-i * minuteTimeInterval)
                )
            )
            channels.append(duplicateTimeChannel)
            channels.append(duplicateTimeChannel)
        }
        for _ in 15..<20 {
            channels.append(
                ChannelModel(identifier: nil,
                             name: "",
                             lastMessage: nil,
                             lastActivity: nil)
            )
        }
    }
    
    func testSort() {
        channels.shuffle()
        let chat = channelsSorter.sortAndSplit(channels)
        for i in 1 ..< chat.onlineChannels.count {
            XCTAssertTrue(!DateUtils.compareByDate(chat.onlineChannels[i - 1].lastActivity, chat.onlineChannels[i].lastActivity))
        }
        if !chat.onlineChannels.isEmpty && !chat.historyChannels.isEmpty {
            XCTAssertTrue(!DateUtils.compareByDate(chat.onlineChannels.last?.lastActivity, chat.historyChannels.first?.lastActivity))
        }
        for i in 1 ..< chat.historyChannels.count {
            XCTAssertTrue(!DateUtils.compareByDate(chat.historyChannels[i - 1].lastActivity, chat.historyChannels[i].lastActivity))
        }
    }
    
    func testSplit() {
        channels.shuffle()
        let chat = channelsSorter.sortAndSplit(channels)
        for channel in chat.onlineChannels {
            XCTAssertTrue(DateUtils.isRecentlyDate(channel.lastActivity))
        }
        for channel in chat.historyChannels {
            XCTAssertFalse(DateUtils.isRecentlyDate(channel.lastActivity))
        }
    }
}
