//
//  StrengthRule.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

protocol GameRule {
    
    var cardOrder: [Int] { get set }
    var suitOrder: [String] { get set }
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int
    
    func messageReceivedHandler(_ notification: Notification)
}
