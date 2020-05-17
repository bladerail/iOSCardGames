//
//  GameManager.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 12/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol GameManager {
    var playerList: [MCPeerID] { get set }
    var playerIndex: Int { get set }
    var currentGameRule: GameLogic? { get set }
    
    func packetReceivedHandler(packet: NPacket)
    func sendPacket(packet: NPacket)
    
}
