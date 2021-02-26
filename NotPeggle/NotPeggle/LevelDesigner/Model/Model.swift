//
//  Model.swift
//  NotPeggle
//
//  Created by Ying Gao on 25/1/21.
//

/**
 Representation of the data on the board of pegs in the UI.
 A `Model` is identified by its name and its collection of `Pegs`.
 A `Peg` can only be added to the model if it does not overlap with other existing pegs.
 It supports operations for inserting and deleting pegs, as well as querying.
 Note: The model does not store frame data and is hence unable to check the validity
 of the `Peg` coordinates with respect to the UI frame.
 */
struct Model: Equatable, Codable {

    var levelName: String

    // Not the most optimal way of coding, but if I made LevelObject hashable then it wouldn't compile.
    var pegs: Set<Peg>
    var blocks: Set<Block>

    var width: Double
    var height: Double

    /// Constructs a `Model` with a given name and list of pegs.
    /// The given pegs are only added if they do not overlap with other pegs stored.
    init?(name: String, pegs: [Peg], blocks: [Block], width: Double, height: Double) {
        guard width > 0, height > 0 else {
            return nil
        }
        levelName = name
        self.pegs = []
        self.blocks = []
        self.width = width
        self.height = height

        pegs.forEach { insert(peg: $0) }
        blocks.forEach { insert(block: $0) }
        assert(checkRepresentation())
    }

    /// Constructs an empty, unnamed `Model`.
    init?(width: Double, height: Double) {
        let emptyString = ""
        self.init(name: emptyString, pegs: [], blocks: [], width: width, height: height)
    }

    /// Checks if the given `Peg` exists in the model.
    func contains(_ peg: Peg) -> Bool {
        pegs.contains(peg)
    }

    /// Checks if the given `Peg` exists in the model.
    func contains(_ block: Block) -> Bool {
        blocks.contains(block)
    }

    /// Checks if the given `LevelObject` can be added to the model.
    /// This is only true if it does not overlap with at least one `Peg` and does not overlap with the borders).
    func canAccommodate(object: LevelObject) -> Bool {
        let isWithinBorders = fitsOnBoard(object: object)
        let doesNotClash = pegs.allSatisfy { !$0.overlapsWith(other: object) }
            && blocks.allSatisfy { !$0.overlapsWith(other: object) }
        return isWithinBorders && doesNotClash
    }

    /// Checks if a new `Peg` can replace a previous `Peg` in the model without overlapping with other `Peg`s.
    /// This can be used to check if `oldPeg` can be moved to another location represented by `newPeg`.
    /// If `oldPeg` does not exist in the `Model`
    /// it simply returns the result of calling `canAccommodate(object:)` on `newPeg`.
    func canAccommodate(_ newPeg: Peg, excluding oldPeg: Peg) -> Bool {
        let isWithinBorders = fitsOnBoard(object: newPeg)

        let doesNotClashWithPegs = pegs.filter { $0 != oldPeg }
            .allSatisfy { !$0.overlapsWith(other: newPeg) }
        let doesNotClashWithBlocks = blocks.allSatisfy { !$0.overlapsWith(other: newPeg) }
        let doesNotClash = doesNotClashWithPegs && doesNotClashWithBlocks

        return isWithinBorders && doesNotClash
    }

    /// Checks if a new `Block` can replace a previous `Block` in the model without overlapping with other `Block`s.
    /// This can be used to check if `oldBlock` can be moved to another location represented by `newBlock`.
    /// If `oldBlock` does not exist in the `Model`
    /// it simply returns the result of calling `canAccommodate(object:)` on `newBlock`.
    func canAccommodate(_ newBlock: Block, excluding oldBlock: Block) -> Bool {
        let isWithinBorders = fitsOnBoard(object: newBlock)

        let doesNotClashWithPegs = pegs.allSatisfy { !$0.overlapsWith(other: newBlock) }
        let doesNotClashWithBlocks = blocks.filter { $0 != oldBlock }
            .allSatisfy { !$0.overlapsWith(other: newBlock) }
        let doesNotClash = doesNotClashWithPegs && doesNotClashWithBlocks

        return isWithinBorders && doesNotClash
    }

    /// Checks if the given `object` fits within the boards of the game area.
    func fitsOnBoard(object: LevelObject) -> Bool {
        !object.tooCloseToEdges(width: width, height: height)
    }

    /// Returns the first `Peg` that satisfies the given predicate.
    func firstPeg(where predicate: (Peg) -> Bool) -> Peg? {
        pegs.first(where: predicate)
    }

    /// Returns the first `Block` that satisfies the given predicate.
    func firstBlock(where predicate: (Block) -> Bool) -> Block? {
        blocks.first(where: predicate)
    }

    /// Saves a new `Peg` in the model only if it does not overlap with any other existing `LevelObject`s.
    mutating func insert(peg: Peg) {
        assert(checkRepresentation())
        if !canAccommodate(object: peg) {
            return
        }
        pegs.insert(peg)
        assert(checkRepresentation())
    }

    /// Deletes a `Peg` from the `Model` if it exists.
    mutating func delete(peg: Peg) {
        assert(checkRepresentation())
        pegs.remove(peg)
        assert(checkRepresentation())
    }

    /// Saves a new `Block` in the model only if it does not overlap with any other existing `LevelObject`s.
    mutating func insert(block: Block) {
        assert(checkRepresentation())
        if !canAccommodate(object: block) {
            return
        }
        blocks.insert(block)
        assert(checkRepresentation())
    }

    /// Deletes a `Block` from the `Model` if it exists.
    mutating func delete(block: Block) {
        assert(checkRepresentation())
        blocks.remove(block)
        assert(checkRepresentation())
    }

    /// Replaces an existing `Peg` with a given replacement only if the
    /// two conditions below are satisfied:
    ///   * The given `newPeg` does not overlap with any other existing `LevelObject`
    ///   * The `oldPeg` exists in the model.
    mutating func replace(_ oldPeg: Peg, with newPeg: Peg) {
        assert(checkRepresentation())
        guard
            contains(oldPeg),
            canAccommodate(newPeg, excluding: oldPeg)
        else {
            return
        }

        delete(peg: oldPeg)
        insert(peg: newPeg)
        assert(checkRepresentation())
    }

    /// Replaces an existing `Block` with a given replacement only if the
    /// two conditions below are satisfied:
    ///   * The given `newBlock` does not overlap with any other existing `LevelObject`
    ///   * The `oldBlock` exists in the model.
    mutating func replace(_ oldBlock: Block, with newBlock: Block) {
        assert(checkRepresentation())
        guard
            contains(oldBlock),
            canAccommodate(newBlock, excluding: oldBlock)
        else {
            return
        }

        delete(block: oldBlock)
        insert(block: newBlock)
        assert(checkRepresentation())
    }

    /// Clears all pegs.
    mutating func removeAll() {
        pegs = []
        blocks = []
    }

    /// Checks that no stored `Peg` overlaps with another at any point in time.
    private func checkRepresentation() -> Bool {
        checkPegs() && checkBlocks()
    }

    private func checkPegs() -> Bool {
        var elements: [Peg] = []
        for peg in pegs {
            if !fitsOnBoard(object: peg) {
                return false
            }
            if elements.contains(where: { $0.overlapsWith(other: peg) }) {
                return false
            }
            elements.append(peg)
        }
        return true
    }

    private func checkBlocks() -> Bool {
        var elements: [Block] = []
        for block in blocks {
            if !fitsOnBoard(object: block) {
                return false
            }
            if elements.contains(where: { $0.overlapsWith(other: block) }) {
                return false
            }
            elements.append(block)
        }
        return true
    }
}
