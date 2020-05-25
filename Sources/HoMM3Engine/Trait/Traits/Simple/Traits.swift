//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public struct Battlefield {}
public extension Battlefield {
    struct Trait: HoMM3Engine.Trait, TraitInitializable {

        public let uniqueName: CamelCasedStringAaZz
        public let displayName: String
        public let detailedDescription: String
        
        public init(
            uniqueName: CamelCasedStringAaZz,
            displayName: String,
            detailedDescription: String
        ) {
            self.uniqueName = uniqueName
            self.displayName = displayName
            self.detailedDescription = detailedDescription
        }
    }
}
public extension Battlefield.Trait {
    static let obstacle = Self(
        name: "Obstacle",
        detailedDescription: "Blocks creature movement on battlefield."
    )
}


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

public extension AnyTrait {
    static let flying = Self(
        name: "Flying",
        detailedDescription: "Can fly over other creatures, obstacles and castle walls on battlefield. A general observation is that flying creatures are often faster (in terms of 'speed' than non-flying creatures)"
    ).negating(Battlefield.Trait.obstacle)
    
    static let breathAttack = Self(
        name: "Breath Attack",
        detailedDescription: "Fire breathing for example, can attack through multiple hexes on the battlefield, i.e. attack two targets standing in a row."
    )
    
    static let noEnemyRetaliation = Self(
        name: "No enemy retaliation",
        detailedDescription: "Allows this creature to attack another without being hit back."
    )
    
    static let dragon = Self(
        name: "Dragon",
        detailedDescription: "Dragons are such mythologically profound creatures that they merit their own trait, some artifacts in the game such as 'Vial of Dragon Blood' and WoG artifact 'Dragonheart' relates to all creatures being dragons."
    )
}
