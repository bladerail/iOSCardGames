//
//  ChatBubble.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 11/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit

class ChatBubble: NSObject {

    var msg: String
    var sender: String
    var ts : NSDate
    var rowHeight : CGFloat
    
    init(withMsg text:String, by who:String, on date:NSDate) {
        self.msg = text
        self.sender = who    // Self or usernames
        self.ts = date
        self.rowHeight = 0.0
    }
    
    func setRowHeight(_ h:CGFloat) {
        rowHeight = h
    }
    
    func getRowHeight() -> CGFloat {
        return rowHeight
    }
    
    func getMsg() -> String {
        return self.msg
    }
    
    func getSender() -> String {
        return self.sender
    }
    
    func getTS() -> NSDate {
        return self.ts
    }
}
