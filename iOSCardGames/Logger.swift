//
//  Logger.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

open class Logger {
    
    public static func d(file : String = #file,
                         line : Int = #line,
                         function : String = #function, _ msg: String) {
        let fileName = (file as NSString).lastPathComponent
        print("[D]: \(fileName) \(line) \(function): \(msg)")
    }
}
