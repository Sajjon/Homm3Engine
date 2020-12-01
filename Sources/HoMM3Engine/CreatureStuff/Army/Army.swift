//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public struct Army: CustomStringConvertible {
    
    public let hero: Hero?
    public let creatureStacks: [Creature.Stack]
    
    public init(
        hero: Hero?,
        creatureStacks: [Creature.Stack]
    ) {
        self.hero = hero
        self.creatureStacks = creatureStacks
    }
}


public extension Army {
    var description: String {
        if let hero = hero {
            return "\(hero) \(creatureStacks) "
        } else {
            return String(describing: creatureStacks)
        }
    }
}
