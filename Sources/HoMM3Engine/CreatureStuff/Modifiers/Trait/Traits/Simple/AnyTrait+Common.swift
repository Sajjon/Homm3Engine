//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

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
    
    /// Zombies have a 20% to cause disease which lowers target attack and defense by 2 for 3 rounds
    static let disease = Self(
        name: "Disease",
        detailedDescription: "Zombies have disease special ability, which may occur before the target stack has a chance to retaliate. The attack has 20% chance of causing the target to become ill, which causes the target stack to have their attack and defense values reduced by two for a period of three rounds. Disease can only be removed with Cure spell."
    )
}
