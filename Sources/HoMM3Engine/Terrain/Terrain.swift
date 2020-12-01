//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public struct Terrain: Hashable, CustomStringConvertible {
    public let displayName: String
    public let movementCost: MovementCost
}

public extension Terrain {
    var description: String { displayName }
}
