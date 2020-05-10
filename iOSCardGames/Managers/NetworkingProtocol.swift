//
//  NetworkingProtocol.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
protocol NetworkingProtocol {
    
    func hostSession()
    func findSessions()
    func joinSession()
    func leaveSession()
    
    func sendMessage()
    func receiveMessage()
}
