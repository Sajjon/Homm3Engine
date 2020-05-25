//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public struct Spell: Modifier, Equatable {
    public let context: Context
    public let name: String
}

public extension Spell {
    struct Context: Equatable, ExpressibleByStringLiteral {
        public let name: String
        public init(name: String) {
            self.name = name
        }
        public init(stringLiteral value: String) {
            self.init(name: value)
        }
    }
    static func combat(_ name: String) -> Self {
        .init(context: .combat, name: name)
    }
}

public extension Spell.Context {
    static let combat: Self = "combat"
    static let worldMap: Self = "worldMap"
}

public extension Spell {
    static let curse: Spell = .combat("Curse")
    static let bloodlust: Spell = .combat("Bloodlust")
}
