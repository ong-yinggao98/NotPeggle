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
    var pegs: Set<Peg>

    var width: Double
    var height: Double

    /// Constructs a `Model` with a given name and list of pegs.
    /// The given pegs are only added if they do not overlap with other pegs stored.
    init?(name: String, pegs: [Peg], width: Double, height: Double) {
        guard width > 0, height > 0 else {
            return nil
        }
        levelName = name
        self.pegs = []
        self.width = width
        self.height = height
        for peg in pegs {
            insert(peg: peg)
        }
        assert(checkRepresentation())
    }

    /// Constructs an empty, unnamed `Model`.
    init?(width: Double, height: Double) {
        let emptyString = ""
        self.init(name: emptyString, pegs: [], width: width, height: height)
    }

    /// Checks if the given `Peg` exists in the model.
    func contains(_ peg: Peg) -> Bool {
        pegs.contains(peg)
    }

    /// Checks if the given `Peg` can be added to the model.
    /// This is only true if it does not overlap with at least one `Peg` and does not overlap with the borders).
    func canAccommodate(peg: Peg) -> Bool {
        let isWithinBorders = fitsOnBoard(peg: peg)
        let doesNotClash = pegs.allSatisfy { !$0.overlapsWith(peg: peg) }
        return isWithinBorders && doesNotClash
    }

    /// Checks if a new `Peg` can replace a previous `Peg` in the model without overlapping with other `Peg`s.
    /// This can be used to check if `oldPeg` can be moved to another location represented by `newPeg`.
    /// If `oldPeg` does not exist in the `Model`
    /// it simply returns the result of calling `canAccommodate(peg:)` on `newPeg`.
    func canAccommodate(_ newPeg: Peg, excluding oldPeg: Peg) -> Bool {
        let isWithinBorders = fitsOnBoard(peg: newPeg)
        let doesNotClash = pegs.filter { $0 != oldPeg }
            .allSatisfy { !$0.overlapsWith(peg: newPeg) }
        return isWithinBorders && doesNotClash
    }

    /// Checks if the given peg fits within the boards of the game area.
    func fitsOnBoard(peg: Peg) -> Bool {
        !peg.tooCloseToEdges(width: width, height: height)
    }

    /// Returns the first `Peg` that satisfies the given predicate.
    func first(where predicate: (Peg) -> Bool) -> Peg? {
        pegs.first(where: predicate)
    }

    /// Saves a new `Peg` in the model only if it does not overlap with any other existing `Peg`.
    mutating func insert(peg: Peg) {
        assert(checkRepresentation())
        if !canAccommodate(peg: peg) {
            return
        }
        pegs.insert(peg)
        assert(checkRepresentation())
    }

    /// Deletes a `Peg` from the `Model` if it exists.
    mutating func delete(peg: Peg) {
        assert(checkRepresentation())
        let index = pegs.firstIndex(of: peg)
        guard let indexToRemove = index else {
            return
        }
        pegs.remove(at: indexToRemove)
        assert(checkRepresentation())
    }

    /// Replaces an existing `Peg` with a given replacement only if the
    /// two conditions below are satisfied:
    ///   * The given `newPeg` does not overlap with any other existing `Peg`
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

    /// Clears all pegs.
    mutating func removeAllPegs() {
        pegs = []
    }

    /// Checks that no stored `Peg` overlaps with another at any point in time.
    private func checkRepresentation() -> Bool {
        var elements: [Peg] = []
        for peg in pegs {
            if !fitsOnBoard(peg: peg) {
                return false
            }
            if elements.contains(where: { $0.overlapsWith(peg: peg) }) {
                return false
            }
            elements.append(peg)
        }
        return true
    }
}
