//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-26.
//

import Foundation

extension RawRepresentable where Self: CustomStringConvertible, RawValue == String {
    public var description: String { rawValue }
}

public extension Hero {
    struct Trivia: Hashable, Codable, CustomStringConvertible {
        public let name: String
        public let heroClass: HeroClass
        public let gender: Gender
        public let race: Race
        public let biography: String
    }
}

// MARK: CustomStringConvertible
public extension Hero.Trivia {
    var description: String {
        name
    }
}

public extension Hero.Trivia {
    enum Gender: String, Hashable, Codable, CustomStringConvertible {
        case male, female
    }
    
    struct Race: Hashable, Codable, CustomStringConvertible, ExpressibleByStringLiteral {
        public let name: String
        public init(name: String) {
            self.name = name
        }
        public init(stringLiteral value: String) {
            self.init(name: value)
        }
        public var description: String { name }
    }
}

public extension Hero.Trivia.Race {
    static let genie: Self = "Genie"
    static let human: Self = "Human"
}

public extension Hero {
    struct SpellBook: Hashable, Codable, ExpressibleByArrayLiteral {
        public let spells: [Spell]
        public init(spells: [Spell]) {
            self.spells = spells
        }
        public init(arrayLiteral elements: Spell...) {
            self.init(spells: elements)
        }
    }
}

public extension Hero {
    struct MovementPoints: Hashable, Codable, CustomStringConvertible {
        public typealias Value = UInt
        public let minimum: Value
        public let maximum: Value
        
        public init(
            // values taken from Solmyr
            //  https://heroes.thelazy.net/index.php/Solmyr
            minimum: Value = 1500,
            maximum: Value = 1560
        ) {
            precondition(minimum <= maximum)
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}

public extension Hero.MovementPoints {
    var description: String {
        "\(minimum) - \(maximum)"
    }
}

public extension Hero {
    typealias Level = NewType<LevelTag>
    final class LevelTag: UIntTagBase {}
}


public struct Hero: Hashable, Codable, CustomStringConvertible {
    
    public let trivia: Trivia
    public let level: Level
    public let owner: Player
    public let specialty: Specialty
    public let primarySkills: PrimarySkills
    public let secondarySkills: [SecondarySkill]
    public let spellBook: SpellBook?
    public let movementPoints: MovementPoints
    public let artifacts: [Artifact]
    
    public init(
        trivia: Trivia,
        level: Level = 1,
        owner: Player,
        specialty: Specialty,
        primarySkills: PrimarySkills? = nil,
        secondarySkills:  [SecondarySkill],
        spellBook: SpellBook? = nil,
        movementPoints: MovementPoints = .init(),
        artifacts: [Artifact] = []
    ) {
        self.trivia = trivia
        self.level = level
        self.owner = owner
        self.specialty = specialty
        self.primarySkills = primarySkills ?? trivia.heroClass.startingPrimarySkills
        self.secondarySkills = secondarySkills
        self.spellBook = spellBook
        self.movementPoints = movementPoints
        self.artifacts = artifacts
    }
}

public extension Hero {
    enum Specialty: Hashable, Codable {
        case secondarySkill(SecondarySkillType)
        case creature(Creature)
        case creatureStats(Creature.Stats)
        case spell(Spell)
    }
}

public extension Hero.Specialty {
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    init(from decoder: Decoder) throws {
        fatalError()
    }
}

public extension Hero {
    
    var name: String { trivia.name }
    
    func hasSpecialty(skill skillTypeToCheckFor: SecondarySkillType) -> Bool {
        guard case let .secondarySkill(heroSpecialtySkillType) = specialty else { return false }
        return heroSpecialtySkillType == skillTypeToCheckFor
    }
    
    func hasSpecialty(spell spellToCheckFor: Spell) -> Bool {
        guard case let .spell(heroSpecialtySpell) = specialty else { return false }
        return heroSpecialtySpell == spellToCheckFor
    }
}

// MARK: CustomStringConvertible
public extension Hero {
    var description: String { name }
}
