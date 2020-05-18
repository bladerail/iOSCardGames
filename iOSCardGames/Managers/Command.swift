//
//  Commands.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 17/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

enum Command {
    case bridge(BridgeCmd)
    case simple(SimpleCmd)

}

enum SimpleCmd: String {
    case HOST
    case CHAT
    case SETGAME
}

extension Command: Codable {
    
    enum CodingKeys: String, CodingKey {
        case bridge
        case simple
    }
    
    enum CodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let bridgeValue = try? values.decode(String.self, forKey: .bridge) {
            self = .bridge(BridgeCmd(rawValue: bridgeValue)!)
            return
        }
        if let simpleValue = try? values.decode(String.self, forKey: .simple) {
            self = .simple(SimpleCmd(rawValue: simpleValue)!)
            return
        }
        throw CodingError.decoding("Decoding failed")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .bridge(value):
            try container.encode(value.rawValue, forKey: .bridge)
        case let .simple(value):
            try container.encode(value.rawValue, forKey: .simple)
        }
    }
    
}
