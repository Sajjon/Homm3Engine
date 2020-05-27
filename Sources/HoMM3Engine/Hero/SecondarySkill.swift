//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

public struct SecondarySkill: Hashable, Codable, CustomStringConvertible {
    
    public let skillType: SecondarySkillType
    public let skillLevel: SecondarySkillLevel
    public init(type: SecondarySkillType, level: SecondarySkillLevel) {
        self.skillType = type
        self.skillLevel = level
    }
}

public struct SecondarySkillType: Hashable, Codable, CustomStringConvertible, ExpressibleByStringLiteral {
    public let name: String
    public init(name: String) {
        self.name = name
    }
    public init(stringLiteral value: String) {
        self.init(name: value)
    }
    public var description: String { name }
}

// MARK: CustomStringConvertible
public extension SecondarySkill {
    var description: String {
        "\(skillLevel) \(skillType)"
    }
}

public extension SecondarySkill {
    static func basic(_ skillType: SecondarySkillType) -> Self {
        .init(type: skillType, level: .basic)
    }
    
    static func advanced(_ skillType: SecondarySkillType) -> Self {
        .init(type: skillType, level: .advanced)
    }
    
    static func expert(_ skillType: SecondarySkillType) -> Self {
        .init(type: skillType, level: .expert)
    }
}

public extension SecondarySkillType {
    static let airMagic: Self = "Air Magic"
    static let archery: Self = "Archery"
    static let armory: Self = "Armory"
    static let artillery: Self = "Artillery"
    static let ballistics: Self = "Ballistics"
    static let diplomacy: Self = "Diplomacy"
    static let eagleEye: Self = "Eagle Eye"
    static let earthMagic: Self = "Earth Magic"
    static let estates: Self = "Estates"
    static let firstAid: Self = "First Aid"
    static let fireMagic: Self = "Earth Magic"
    static let intelligence: Self = "Intelligence"
    static let leadership: Self = "Leadership"
    static let logistics: Self = "Logistics"
    static let luck: Self = "Luck"
    static let mysticism: Self = "Mysticism"
    static let nagivation: Self = "Navigation"
    static let offense: Self = "Offense"
    static let pathfinding: Self = "Pathfinding"
    static let resistance: Self = "Resistance"
    static let scholar: Self = "Scholar"
    static let scounting: Self = "Scounting"
    static let sourcery: Self = "Sourcery"
    static let tactics: Self = "Tactics"
    static let waterMagic: Self = "Water Magic"
    static let wisdom: Self = "Wisdom"
}


public struct SecondarySkillLevel: Hashable, Codable, CustomStringConvertible, ExpressibleByStringLiteral {
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
