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
    
    /// This will retain a trait `T` even when the last creature has been 'revoked; of that trait by calling `removeTrait`.
    private var allKnownTraits = Set<AnyTrait>()
    
    private var traitsForCreatures: [Creature: Set<AnyTrait>] = [:]
}

public extension CreatureTraitsLedger {
    static func traits(of creature: Creature) -> Set<AnyTrait> {
        shared.traits(of: creature)
    }
    
    static func lookupTrait(named uniqueTraitName: String) -> AnyTrait? {
        shared.allKnownTraits.first(where: { $0.uniqueName == .init(value: uniqueTraitName) })
    }
    
    /// Returns `true` iff the creatue had the trait (before removal) else `false`.
    @discardableResult
    static func removeTrait<T>(_ trait: T, from creature: Creature) -> Bool where T: Trait {
        shared.removeTrait(trait, from: creature)
    }
    
    static func addTrait<T>(_ trait: T, to creature: Creature) where T: Trait {
        shared.allKnownTraits.insert(AnyTrait(trait: trait))
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
    func removeTrait<T>(_ trait_: T, from creature: Creature) -> Bool where T: Trait {
        let trait = AnyTrait(trait: trait_)
        var foundTraits = traits(of: creature)
        let hadTrait = foundTraits.contains(trait)
        foundTraits.remove(trait)
        traitsForCreatures[creature] = foundTraits
        return hadTrait
    }
    
    func addTrait<T>(_ trait_: T, to creature: Creature) where T: Trait {
        let trait = AnyTrait(trait: trait_)
        var foundTraits = traits(of: creature)
        foundTraits.insert(trait)
        traitsForCreatures[creature] = foundTraits
    }
    
    func does<T>(creature: Creature, haveTrait trait_: T) -> Bool where T: Trait {
        traits(of: creature).contains(AnyTrait(trait: trait_))
    }
}
