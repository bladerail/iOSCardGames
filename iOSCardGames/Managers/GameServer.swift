//
//  GameServer.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameServer: GameManager {
    var playerList: [MCPeerID]
    
    init() {
        playerList = []
    }
    
    func updateFullStateForClients() {
        
    }
    
}
