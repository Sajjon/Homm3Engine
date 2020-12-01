//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Terrain {
    
    static let grass = Self.declare("Grass")
    static let dirt = Self.declare("Dirt")

    static let lava = Self.declare("Lava")
    static let subterranean = Self.declare("Subterranean")
    static let water = Self.declare("Water")
    
    static let rough = Self.declare("Grass", movementCost: (125, 176))

    static let sand = Self.declare("Sand", movementCost: (150, 212))
    static let snow = Self.declare("Snow", movementCost: (150, 212))
    static let swamp = Self.declare("Swamp", movementCost: (175, 247))

    static let roadDirt = Self.declare("Dirt road", movementCost: (75, 106))
    static let roadGravel = Self.declare("Gravel Road", movementCost: (65, 91))
    static let roadCobbleStone = Self.declare("Cobblestone Road", movementCost: (50, 70))
    static let favorableWind    = Self.declare("Favorable Wind", movementCost: (66, 93))
}

private extension Terrain {
    static func declare(
        _ displayName: String,
        movementCost: (
        straight: MovementCost.Cost,
        diagnonal: MovementCost.Cost) = (100, 141)
    ) -> Self {
        Self(
            displayName: displayName,
            movementCost: .init(straightMove: movementCost.straight, diagonalMove: movementCost.diagnonal))
    }
}
