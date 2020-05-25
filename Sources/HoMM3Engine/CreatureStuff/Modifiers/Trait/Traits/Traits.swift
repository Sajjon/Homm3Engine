//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

/// An empty enum, providing a shared context for all traits
public enum Traits {
    
    /// Never removes any traits...
    private static var allKnownTraits = Set<AnyTrait>()
    
    /// `["obstacle": Set(["flying", ...])`
    internal private(set) static var negatedBy = [AnyTrait: Set<AnyTrait>]()
    
    /// inverse of `negatedBy`
    /// `["flying": Set(["obstacle", ...])`
    internal private(set) static var negatingTraits = [AnyTrait: Set<AnyTrait>]()
}

internal extension Traits {
    static func insert<T>(_ trait: T) where T: Trait {
        allKnownTraits.insert(trait.eraseToAnyTrait())
    }
    
    static func lookupTrait(named uniqueTraitName: String) -> AnyTrait? {
        allKnownTraits.first(where: { $0.uniqueName == .init(value: uniqueTraitName) })
    }
    
    static func mark<T, U>(trait negatedTrait: T, asNegatedBy negatingTrait: U) where T: Trait, U: Trait {
        negatedBy[negatedTrait.eraseToAnyTrait()] += negatingTrait.eraseToAnyTrait()
        mark(trait: negatingTrait, asNegating: negatedTrait)
    }
    
    private static func mark<T, U>(trait negatingTrait: T, asNegating traitBeingNegated: U) where T: Trait, U: Trait {
        negatingTraits[negatingTrait.eraseToAnyTrait()] += traitBeingNegated.eraseToAnyTrait()
    }
}
