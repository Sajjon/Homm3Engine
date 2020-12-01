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


public final class Hero: Codable, CustomStringConvertible {
    
    public let trivia: Trivia

    public private(set) var experiencePoints: ExperiencePoints
    public let owner: Player
    public let specialty: Specialty
    public let primarySkills: PrimarySkills
    public let secondarySkills: [SecondarySkill]
    public let spellBook: SpellBook?
    public let movementPoints: MovementPoints
    public let artifacts: [Artifact]
    
    public init(
        trivia: Trivia,
        experiencePoints: ExperiencePoints = 0,
        owner: Player,
        specialty: Specialty,
        primarySkills: PrimarySkills? = nil,
        secondarySkills:  [SecondarySkill],
        spellBook: SpellBook? = nil,
        movementPoints: MovementPoints = .init(),
        artifacts: [Artifact] = []
    ) {
        self.trivia = trivia
        self.experiencePoints = experiencePoints
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
    
    static func levelFromExperiencePoints(_ experiencePoints: ExperiencePoints) -> Level {
        guard
            let (levelPlus1, _) = experiencePointsRequiredPerLevel.enumerated().first(where: { $0.element > experiencePoints })
        else {
            fatalError("No level found for XP: \(experiencePoints)")
        }
        
//        let level = experiencePointsRequiredPerLevel[indexOfLevelPlus1 - 1]
        return Level(levelPlus1 - 1)
    }
    
    /// https://heroes.thelazy.net/index.php/Experience
    static let experiencePointsRequiredPerLevel: [ExperiencePoints] = [
        0,
        1_000,
        2_000,
        3_200,
        4_600,
        6_200,
        8_000,
        10_000,
        12_200,
        14_700,
        17_500,
        20_600,
        24_320,
        28_784,
        34_140,
        40_567,
        48_279,
        57_533,
        68_637,
        81_961,
        97_949,
        117_134,
        140_156,
        167_782,
        200_933,
        240_714,
        288_451,
        345_735,
        414_475,
        496_963,
        595_948,
        714_730,
        857_268,
        1_028_313,
        1_233_567,
        1_479_871,
        1_775_435,
        2_130_111,
        2_555_722,
        3_066_455,
        3_679_334,
        4_414_788,
        5_297_332,
        6_356_384,
        7_627_246,
        9_152_280,
        10_982_320,
        13_178_368,
        15_813_625,
        18_975_933,
        22_770_702,
        27_324_424,
        32_788_890,
        39_346_249,
        47_215_079,
        56_657_675,
        67_988_790,
        81_586_128,
        97_902_933,
        117_483_099,
        140_979_298,
        169_174_736,
        203_009_261,
        243_610_691,
        292_332_407,
        350_798_466,
        420_957_736,
        505_148_860,
        606_178_208,
        727_413_425,
        872_895_685,
        1_047_474_397,
        1_256_968_851,
        1_508_362_195
    ]
    
    var level: Level {
        Hero.levelFromExperiencePoints(self.experiencePoints)
    }
    
    @discardableResult
    func awardExperiencePoints(_ xpIncrement: ExperiencePoints) -> SelfC {
        self.experiencePoints += xpIncrement
        return self
    }
    
    typealias SelfC = Hero
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

public extension Hero {
    typealias ExperiencePoints = NewType<ExperiencePointsTag>
    final class ExperiencePointsTag: UIntTagBase {}

}
