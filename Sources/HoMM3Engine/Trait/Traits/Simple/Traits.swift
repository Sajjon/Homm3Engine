//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

/// An empty enum, providing a shared context for all traits
@dynamicMemberLookup
public enum Traits {}
public extension Traits {
    static subscript(dynamicMember uniqueName: String) -> AnyTrait {
        guard let trait = CreatureTraitsLedger.lookupTrait(named: uniqueName) else {
            fatalError("Found no trait with uniqueName: <\(uniqueName)> in `CreatureTraitsLedger`. Possible that you have declared the trait, but not added it to any creature. This lookup is only for 'used' traits.")
        }
        return trait
    }
}

public extension AnyTrait {
    static func named(_ name: String, description: String) -> Self {
        .init(
            uniqueName: .init(camelCasing: name),
            displayName: name,
            detailedDescription: description
        )
    }
}

public extension AnyTrait {
    static let flying = Self.named("Flying", description: "Creature that can fly over obstacles on the battlefield in combat, such as water, stones, other creatuers and castle walls.")
    
    static let breathAttack = Self.named("Breath Attack", description: "Fire breathing for example, can attack through multiple hexes on the battlefield, i.e. attack two targets standing in a row.")
    
    static let noEnemyRetaliation = Self.named("No enemy retaliation", description: "Allows this creature to attack another without being hit back.")
    
    static let dragon = Self.named("Dragon", description: "Creature being a dragon.")
}
