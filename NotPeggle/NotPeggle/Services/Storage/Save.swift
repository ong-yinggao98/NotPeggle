//
//  Save.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import Foundation

protocol Save {

    var name: String { get }
    var url: URL { get }

    func toModel() throws -> Model?

    func delete() throws

}
