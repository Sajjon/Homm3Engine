//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

// MARK: Tier
public extension Creature {
    struct Tier: Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible {
        public let level: Int
        public init(level: Int) {
            self.level = level
        }
    }
}

// MARK: ExpressibleByIntegerLiteral
public extension Creature.Tier {
    init(integerLiteral value: Int) {
        self.init(level: value)
    }
}

public extension Creature.Tier {
    static let one: Self = 1
    static let two: Self = 2
    static let three: Self = 3
    static let four: Self = 4
    static let five: Self = 5
    static let six: Self = 6
    static let seven: Self = 7
    static let eight: Self = 8
}

// MARK: CustomStringConvertible
public extension Creature.Tier {
    var description: String { .init(describing: level) }
}
