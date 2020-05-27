//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import Foundation

public struct Army: Hashable, Codable, CustomStringConvertible {
    public let hero: Hero
    public let creatureStacks: [CreatureStack]
}
public extension Army {
    var description: String {
        "\(hero) \(creatureStacks) "
    }
}

public struct Battle: Hashable, Codable, CustomStringConvertible {
    
    public let attacker: Army
    public let defender: Army
    
    private init(attacker: Army, defender: Army) {
        self.attacker = attacker
        self.defender = defender
    }
}

public extension Battle {
    var description: String {
        "\(attacker) vs \(defender) "
    }
}

public extension Battle {
    static func between(attacker: Army, andDefender defender: Army) -> Self {
        .init(attacker: attacker, defender: defender)
    }
}

