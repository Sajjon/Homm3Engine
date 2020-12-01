//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Terrain {
    struct MovementCost: Hashable {
        public let straightMove: Cost
        public let diagonalMove: Cost
    }
}

public extension Terrain.MovementCost {
    typealias Cost = UInt
}
