//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public struct SecondarySkill: Equatable {
    public let skillType: SecondarySkillType
    public let skillLevel: SecondarySkillLevel
    public init(type: SecondarySkillType, level: SecondarySkillLevel) {
        self.skillType = type
        self.skillLevel = level
    }
}

public struct SecondarySkillType: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
    public let name: String
    public init(name: String) {
        self.name = name
    }
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
    public var description: String { name }
}

public extension SecondarySkillType {
    static let archery: Self = "Archery"
    static let offense: Self = "Offsense"
}


public struct SecondarySkillLevel: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
    public let name: String
    public init(name: String) {
        self.name = name
    }
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
    public var description: String { name }
}

public extension SecondarySkillLevel {
    static let basic: Self = "Basic"
    static let advanced: Self = "Advanced"
    static let expert: Self = "Expert"
}
