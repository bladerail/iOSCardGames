//
//  GameClient.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameClient : GameManager {
    
    var playerList: [MCPeerID]
    var playerIndex: Int
    var currentGameRule: GameLogic?
    
    
    init(peers: [MCPeerID], playerIndex: Int) {
        self.playerList = peers
        self.playerIndex = playerIndex
        currentGameRule = nil
    }
    
    func packetReceivedHandler(packet: NPacket) {
        
    }
    
    func sendPacket(packet: NPacket) {
        
    }
    
 
    func requestSyncStateWithServer() {
        
    }
    
    func handleSyncStateWithServer() {
        
    }
    
}
