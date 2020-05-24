//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

// MARK: Faction
public struct Faction: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}

// MARK: ExpressibleByStringLiteral
public extension Faction {
    init(stringLiteral value: String) {
        self.init(name: value)
    }
}

public extension Faction {
    static let conflux:     Self = "Conflux"
    static let dungeon:     Self = "Dungeon"
    static let fortress:    Self = "Fortress"
    static let inferno:     Self = "Inferno"
    static let rampart:     Self = "Rampart"
    static let necropolis:  Self = "Necropolis"
    static let stronghold:  Self = "Stronghold"
    static let castle:      Self = "Castle"
    static let neutral:     Self = "Neutral"
    static let tower:       Self = "Tower"
}

// MARK: CustomStringConvertible
public extension Faction {
    var description: String { name }
}
