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
    var currentGameRule: GameLogic?
    var playerList: [MCPeerID]
    var playerIndex: Int
    
    func packetReceivedHandler(packet: NPacket) {
        
    }
    
    func sendPacket(packet: NPacket) {
        
    }
    
    
    init(peers: [MCPeerID], playerIndex: Int) {
        self.playerList = peers
        self.playerIndex = playerIndex
        currentGameRule = nil
    }
    
    func updateFullStateForClients() {
        
    }
    
}
