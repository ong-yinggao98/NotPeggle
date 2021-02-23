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
}

/// Inherits String for ease of encoding and decoding
enum Color: String, Codable {
    case blue, orange
}
