//
//  BridgeStrengthRule.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

enum BridgeCmd: String {
    case BID
    case PLAYCARD
    case RECEIVECARDS
    case REQUESTSHUFFLE
    case GAMESTAGE
}

class BridgeGameLogic : GameLogic {

    var gameManager: GameManager
    var gameName = GameName.Bridge
    
    enum GameStages: String {
        case start
        case bid
        case play
        case end
    }
    
    let numPlayers = 4
    let playerIndex: Int
    var deck: Deck? = nil
    var playerCards : [[Card]] = [[], [], [], []]
    var cardOrder: [Int] = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1]
    var suitOrder: [String] = ["Club", "Diamond", "Heart", "Spade"];
    var currentGameStage = GameStages.start
    
    init(gm : GameManager, playerIndex: Int) {
        self.gameManager = gm
        self.playerIndex = playerIndex
    }
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int {
        return (cardOrder.firstIndex(of: number)! + 1) + (suit * 13);
    }
    
    func messageReceivedHandler(_ packet: NPacket) {
        let cmd = packet.command
        switch (cmd) {
        case .bridge(let bridgeCmd):
            switch (bridgeCmd) {
            case .REQUESTSHUFFLE:
                // TODO: Present alertController so that host can accept whether or not to shuffle
                break
            case .BID:
                break
            case .RECEIVECARDS:
                do {
                    let cards = try JSONDecoder().decode([Card].self, from: packet.data)
                    playerCards[playerIndex] = cards
                    var str = ""
                    for card in playerCards[playerIndex] {
                        str += card.description + ", "
                    }
                    
                    Logger.d("Received cards \(playerCards[playerIndex])")
                } catch {
                    Logger.e("Error ReceiveCards")
                }
                break
            case .PLAYCARD:
                break
            case .GAMESTAGE:
                do {
                    let rawValue = String(decoding: packet.data, as: UTF8.self)
                    self.currentGameStage = GameStages.init(rawValue: rawValue)!
                    Logger.d("Changed GameStage to \(currentGameStage)")
                } catch {
                    Logger.e("Error setting GameStage")
                }
                break
            }
            break
        default: // Should not happen
            Logger.e("Unexpected command received \(cmd)")
            break
        }
    }

    // Server set up game
    func setupGame() {
        playerCards = [[], [], [], []]
        deck = Deck(suitOrder, computeCardStrength)
        currentGameStage = GameStages.start
        gameManager.sendPacket(packet: NPacket(command: .bridge(.GAMESTAGE), string: GameStages.start.rawValue))
        shuffleAndDealCards()
        Logger.d("playerCards \(playerCards.description)")
        do {
            for playerIndex in 0...3 {
                let jsonCards = try JSONEncoder().encode(playerCards[playerIndex])
                gameManager.sendPacket(packet: NPacket(command: .bridge(.RECEIVECARDS), data: jsonCards, playerIndex: playerIndex))
            }
        } catch {
            Logger.e("Error dealing cards")
        }
    }
    
    func shuffleAndDealCards() {
        deck!.shuffle()
        playerCards = deck!.dealCards(numPlayers: numPlayers)
    }
}
