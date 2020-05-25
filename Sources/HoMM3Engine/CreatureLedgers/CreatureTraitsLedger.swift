//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

// MARK: CreatureTraitsLedger
public final class CreatureTraitsLedger {
    public static let shared = CreatureTraitsLedger()
    
    private var traitsForCreatures: [Creature: Set<AnyTrait>] = [:]
}

public extension CreatureTraitsLedger {
    static func traits(of creature: Creature) -> Set<AnyTrait> {
        shared.traits(of: creature)
    }
    
    /// Returns `true` iff the creatue had the trait (before removal) else `false`.
    @discardableResult
    static func removeTrait<T>(_ trait: T, from creature: Creature) -> Bool where T: Trait {
        shared.removeTrait(trait, from: creature)
    }
    
    static func addTrait<T>(_ trait: T, to creature: Creature) where T: Trait {
        Traits.insert(trait)
        shared.addTrait(trait, to: creature)
    }
    
    static func does<T>(creature: Creature, haveTrait trait: T) -> Bool where T: Trait {
        shared.does(creature: creature, haveTrait: trait)
    }
}

private extension CreatureTraitsLedger {
    func traits(of creature: Creature) -> Set<AnyTrait> {
        traitsForCreatures[creature] ?? .empty
    }
    
    @discardableResult
    func removeTrait<T>(_ trait: T, from creature: Creature) -> Bool where T: Trait {
        traitsForCreatures[creature] -= trait.eraseToAnyTrait()
    }
    
    func addTrait<T>(_ trait: T, to creature: Creature) where T: Trait {
        traitsForCreatures[creature] += trait.eraseToAnyTrait()
    }
    
    func does<T>(creature: Creature, haveTrait trait: T) -> Bool where T: Trait {
        traits(of: creature).contains(trait.eraseToAnyTrait())
    }
}
