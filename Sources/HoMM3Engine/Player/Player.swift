//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public struct Player: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
    public let name: String
}

public extension Player {
    init(stringLiteral value: String) {
        self.init(name: value)
    }
}

public extension Player {
    var description: String { name }
}

public extension Player {
    static let red: Self = "red"
    static let blue: Self = "blue"
}
