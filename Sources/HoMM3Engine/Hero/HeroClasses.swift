//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero.HeroClass {
    static let wizard = Self(
        name: "Wizard",
        nativeFaction: .tower,
        startingPrimarySkills: .init(
            attack: 0,
            defense: 0,
            spellPower: 2,
            knowledge: 3
        )
    )
    
    static let knight = Self.init(
        name: "Knight",
        nativeFaction: .castle,
        startingPrimarySkills: .init(
            attack: 2,
            defense: 2,
            spellPower: 1,
            knowledge: 1
        )
    )
    
    static let battleMage = Self.init(
        name: "Battle Mage",
        nativeFaction: .stronghold,
        startingPrimarySkills: .init(
            attack: 2,
            defense: 1,
            spellPower: 1,
            knowledge: 1
        )
    )
    
    static let barbarian = Self.init(
        name: "Barbarian",
        nativeFaction: .stronghold,
        startingPrimarySkills: .init(
            attack: 4,
            defense: 0,
            spellPower: 1,
            knowledge: 1
        )
    )
}
