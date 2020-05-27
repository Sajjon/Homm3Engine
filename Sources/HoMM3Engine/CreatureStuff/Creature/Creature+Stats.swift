//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

public extension Creature {
    struct Stats: Hashable, Codable {
        /// The maximum health point of this creature, as in, this value does not reflect the
        /// current state of any creature in battle, that might be wounded, but rather, the
        /// maximum health point the creature *type* has.
        public let healthPoints: HealthPoints
        
        /// Either a fixed damage, or more commonly a range from some minimum damage
        /// to some maximum damage.
        public let damage: Damage
        
        /// Determines speed in battle and modifies the heroes number of steps she can walk
        /// out on the adventure map.
        public let speed: Speed
        
        /// The `attack` increases the damage inflicted upon a defending creature unit.
        ///
        /// This damage modifying attribute is countered by the `defense` of the
        /// defending creature.
        public let attack: Attack
        
        
        /// The `defense` decreases the damage inflicted by an attacking creature unit.
        ///
        /// This damage modifying attribute is countered by the `attack` of the
        /// attacking creature.
        public let defense: Defense
    }
}

public extension Creature.Stats {
    typealias HealthPoints = UInt
    typealias Speed = UInt
}

// MARK: Damage
public extension Creature.Stats {
    enum Damage: Hashable, Codable {
        case fixed(Value)
        case range(min: Value, max: Value)
    }
}

public extension Creature.Stats.Damage {
    
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    init(from decoder: Decoder) throws {
        fatalError()
    }
    
    typealias Value = UInt
    
    var minumumDamage: Value {
        switch self {
        case .fixed(let fixedValue): return fixedValue
        case .range(let min, _): return min
        }
    }
    
    var maximumDamage: Value {
        switch self {
        case .fixed(let fixedValue): return fixedValue
        case .range(_, let max): return max
        }
    }
}

// MARK: Delta

public extension Creature.Stats {
    func newAttack(_ newAttack: Attack) -> Self {
        .init(
            healthPoints: healthPoints,
            damage: damage,
            speed: speed,
            attack: newAttack,
            defense: defense
        )
    }
    
    func newDefense(_ newDefense: Defense) -> Self {
        .init(
            healthPoints: healthPoints,
            damage: damage,
            speed: speed,
            attack: attack,
            defense: newDefense
        )
    }
    
    func newSpeed(_ newSpeed: Speed) -> Self {
        .init(
            healthPoints: healthPoints,
            damage: damage,
            speed: newSpeed,
            attack: attack,
            defense: defense
        )
    }
    
    func newHealthPoints(_ newHealthPoints: HealthPoints) -> Self {
        .init(
            healthPoints: newHealthPoints,
            damage: damage,
            speed: speed,
            attack: attack,
            defense: defense
        )
    }
    
    func newDamage(_ newDamage: Damage) -> Self {
        .init(
            healthPoints: healthPoints,
            damage: newDamage,
            speed: speed,
            attack: attack,
            defense: defense
        )
    }
}


