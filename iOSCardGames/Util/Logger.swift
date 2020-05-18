//
//  Logger.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

open class Logger {
    
    static let notificationCenter = NotificationCenter.default
    
    static var logs : [String] = []
    
    public static func d(file : String = #file,
                         line : Int = #line,
                         function : String = #function, _ msg: String) {
        let fileName = (file as NSString).lastPathComponent
        let fullStr = "[Debug]: \(fileName) \(line) \(function): \(msg)"
        let shortStr = "D: \(function): \(msg)"
        log(fullStr, fullStr)
    }
    
    public static func e(file : String = #file,
                         line : Int = #line,
                         function : String = #function, _ msg: String) {
        let fileName = (file as NSString).lastPathComponent
        let fullStr = "[Error]: \(fileName) \(line) \(function): \(msg)"
        let shortStr = "E: \(function): \(msg)"
        log(fullStr, fullStr)
    }
    
    private static func log(_ fullStr: String, _ shortStr: String) {
        print(fullStr)
        logs.append(shortStr)
        notificationCenter.post(name: .refreshLogs, object: nil)
    }
}

extension Notification.Name {
    static var refreshLogs : Notification.Name {
        return .init(rawValue: "Logger.refreshLogs")
    }
}
