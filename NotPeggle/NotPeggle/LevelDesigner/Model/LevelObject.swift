//
//  LevelObject.swift
//  NotPeggle
//
//  Created by Ying Gao on 26/2/21.
//

protocol LevelObject {

    var type: Type { get }

    func overlapsWith(other: LevelObject) -> Bool

    func contains(point: Point) -> Bool

    func tooCloseToEdges(width: Double, height: Double) -> Bool

}

enum Type: Int {
    case peg, block
}
