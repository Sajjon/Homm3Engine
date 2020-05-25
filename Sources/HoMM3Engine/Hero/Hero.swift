//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public struct Hero: Equatable {
    public let name: String
    public let owner: Player
    public let heroClass: HeroClass
    public let primarySkills: PrimarySkills
    public let secondarySkills: [SecondarySkill]
    
    public init(
        name: String,
        owner: Player,
        heroClass: HeroClass,
        secondarySkills:  [SecondarySkill] = [],
        primarySkills: PrimarySkills? = nil
    ) {
        self.name = name
        self.owner = owner
        self.heroClass = heroClass
        self.primarySkills = primarySkills ?? heroClass.startingPrimarySkills
        self.secondarySkills = secondarySkills
    }
}

public extension Hero {
    enum Specialty {
        case secondarySkill(SecondarySkill)
        case creature(Creature)
        case creatureStats(Creature.Stats)
    }
}

