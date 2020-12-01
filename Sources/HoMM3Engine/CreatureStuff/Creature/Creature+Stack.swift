//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-29.
//

import Foundation

public extension Creature {
    struct Stack: Equatable, Codable, CustomStringConvertible {
        public let quantity: Quantity
        public let creatureType: Creature
    }
}

public extension Creature.Stack {
    typealias Quantity = UInt

    var description: String {
        if quantity > 1 {
            return "One \(creatureType)"
        } else {
            return "\(quantity) \(creatureType)s"
        }
    }
}

public extension Creature {
    func stack(of quantity: Stack.Quantity) -> Stack {
        .init(quantity: quantity, creatureType: self)
    }
}
