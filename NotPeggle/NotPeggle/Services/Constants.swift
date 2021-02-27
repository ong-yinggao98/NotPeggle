//
//  Constants.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/1/21.
//

/// Constants used by both Model and View components.
struct Constants {
    static let pegRadius = 25.0
    static let cannonWidth = 100.0
    static let blockHeight = 30.0

    static let gameEndMessage = "Game Over!"
    static let winMessage = "Congrats, You've won, now get the hell out!"
    static let loseMessage = "HAH, You lose! Better luck next time, sucker."
    static let noPegMessage = "Are you seriously trying to play a game with no pegs? Freak."
}

/// Inherits String for ease of encoding and decoding
enum Color: String, Codable {
    case blue, orange, green
}
