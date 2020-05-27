//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public extension Hero {
    struct PrimarySkills: Hashable, Codable {
        public let attack: Attack
        public let defense: Defense
        public let spellPower: SpellPower
        public let knowledge: Knowledge
    }
    
}

public extension Hero.PrimarySkills {
    typealias Knowledge = UInt
    typealias SpellPower = UInt
}
