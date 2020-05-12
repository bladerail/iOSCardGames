//
//  GameManager.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 12/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameManager {
    var playerList: [MCPeerID]
    var playerIndex: Int
    var currentGameRule: GameRule?
    
    init(peers: [MCPeerID], playerIndex: Int) {
        self.playerList = peers
        self.playerIndex = playerIndex
        currentGameRule = nil
    }
    
    func messageReceivedHandler() {
        
    }
}
