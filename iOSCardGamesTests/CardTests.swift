//
//  CardTests.swift
//  iOSCardGamesTests
//
//  Created by Joshua Ng on 11/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//


import XCTest
@testable import iOSCardGames

class CardTests: XCTestCase {
    
    var card1: Card!
    var card2: Card!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let gameRule = StubRule()
        card1 = Card(1, 3, gameRule)
        card2 = Card(2, 1, gameRule)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(card1.strength > card2.strength)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class StubRule : GameRule {
    var cardOrder: [Int] = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1]
    var suitOrder: [String] = ["Club", "Diamond", "Heart", "Spade"];
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int {
        return (cardOrder.firstIndex(of: number)! + 1) + (suit * 13);
    }
}
