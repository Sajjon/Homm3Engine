//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public let RedDragon = Creature.redDragon
public let BlackDragon = Creature.blackDragon

public extension Creature {
    
    // MARK: Tier 7
    static let redDragon = Self.declareNonUpgraded(
        named: "Red Dragon",
        faction: .dungeon,
        tier: .seven,
        stats: .init(
            healthPoints: 180,
            damage: .range(min: 40, max: 50),
            speed: 11,
            attack: 19,
            defense: 19
        )
    )
    .addTrait(.flying)
    .addTrait(.breathAttack)
    
    static let blackDragon = Self.redDragon.upgraded(named: "Black Dragon") { stats in
        stats
            .newHealthPoints(300)
            .newSpeed(15)
            .newAttack(25)
            .newDefense(25)
    }
    .addTrait(.flying)
    .addTrait(.breathAttack)
    
}
