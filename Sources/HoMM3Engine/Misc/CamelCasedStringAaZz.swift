//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation
// MARK: CamelCasedStringAaZz

/// A non empty, camel cased human readable name with leading lower case letter, with only letters [a-zA-Z] that must be unique
public struct CamelCasedStringAaZz: Hashable, Codable, ExpressibleByStringLiteral {
    private let value: String
    public init(value: String) {
        precondition(!value.isEmpty)
        precondition(value.first!.isLowercase)
        precondition(CharacterSet(charactersIn: value).isSubset(of: .letters))
        self.value = value
    }
}

public extension CamelCasedStringAaZz {
    init(camelCasing nonCamelCased: String) {
        self.init(value: nonCamelCased.camelized)
    }
}

// MARK: ExpressibleByStringLiteral
public extension CamelCasedStringAaZz {
    init(stringLiteral value: String) {
        self.init(value: value)
    }
}
