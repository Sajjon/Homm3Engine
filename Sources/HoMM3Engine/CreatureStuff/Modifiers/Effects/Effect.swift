//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-06-06.
//

import Foundation

public struct Effect: Modifier, Hashable, Codable, ExpressibleByStringLiteral {
    public let displayName: String
    
    public init(displayName: String) {
        self.displayName = displayName
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(displayName: value)
    }
}

public extension Effect {
    static let blind: Self = "Blind"
}
