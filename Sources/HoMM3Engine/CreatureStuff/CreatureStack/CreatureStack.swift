//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public enum AttackType: Int, Equatable {
    case melee, ranged
}
public extension AttackType {
    var isRanged: Bool {
        self == .ranged
    }
    var isMelee: Bool {
        self == .melee
    }
}

public extension Combat {
    final class CreatureStack: Codable, CustomStringConvertible {
        
        public private(set) var creatureType: Creature
        public let startingQuantity: Quantity
        
        private var currentQuantity: Quantity
        public private(set) var perishedQuanity: Quantity = 0
//        public var controllingHero: Hero?
        
        private unowned let army: Army
        private unowned let combat: Combat
        public let positionOnBattleField: Battlefield.HexTile
        
        public private(set) var inflictedDamage: Damage?
        
        public private(set) var modifiers = [Modifier]()
        
        public init(
            _ quantity: Quantity,
            type creatureType: Creature,
            army: Army,
            combat: Combat,
            tile: Battlefield.HexTile
        ) {
            self.creatureType = creatureType
            self.army = army
            self.combat = combat
            self.positionOnBattleField = tile
            self.startingQuantity = quantity
            self.currentQuantity = quantity
        }
        
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        public var controllingHero: Hero? { army.hero }
    }
    
}

public extension Combat.CreatureStack {
    
    var quantity: Quantity { currentQuantity }
    
    var description: String {
        "\(currentQuantity) \(creatureType)"
    }
}

// MARK: Private
private extension Combat.CreatureStack {
    
    typealias HPModifier = Creature.Stats.HealthPoints.Magnitude
    
    var creatureHPModifier: Creature.Stats.HealthPoints.Magnitude {
        return 1 // future: look through `self.modifiers`
    }
    
    var creatureHealthPoints: Creature.Stats.HealthPoints {
        creatureHPModifier * creatureType.stats.healthPoints
    }
    
    var healthPointsOfCurrentDefender: Creature.Stats.HealthPoints {
        let healthPointsOfCurrentDefender = creatureHealthPoints - inflictedDamage
        assert(healthPointsOfCurrentDefender > 0)
        return healthPointsOfCurrentDefender
    }
    
    /// Attack modifier, primarily the Hero's attack strength + spells
    var attackModifier: Attack {
        var attackModifier: Attack = controllingHero?.primarySkills.attack ?? 0
        if hasActiveSpell(.bloodlust) {
            attackModifier += 3 // or 6 if Hero has advanced / expert Fire Magic
            // This is NOT a sustainable solution
        }
        if isAffected(by: AnyTrait.disease) {
            attackModifier -= 2
        }
        
        // TODO: take into consideration: "native terrain or hero's creature specialties."
        return attackModifier
    }
    
    /// Creatures attack + modifier, primarily the Hero's attack strength
    var totalAttack: Attack {
        creatureType.stats.attack + attackModifier
    }
    
    /// Defense modifier, primarily the Hero's defense strength + spells
    var defenseModifier: Defense {
        var defenseModifier: Defense = controllingHero?.primarySkills.defense ?? 0
        if isAffected(by: AnyTrait.disease) {
            // This is NOT a sustainable solution
            defenseModifier -= 2
        }
        
        // TODO: take into consideration: "native terrain or hero's creature specialties."
        return defenseModifier
    }
    
    /// Creatures attack + modifier, primarily the Hero's attack strength
    var totalDefense: Defense {
        creatureType.stats.defense + defenseModifier
    }
    
    // https://heroes.thelazy.net/index.php/Damage#The_damage_calculation_formula
    // VCMI: https://github.com/vcmi/vcmi/blob/cc75b859d49c6bf43a1f55769b1a6aad5290d851/lib/battle/CBattleInfoCallback.cpp#L711-L963
    static func calculateDamageInterval(
        causedBy attackingStack: SelfC,
        attacking targetStack: SelfC,
        attackType: AttackType,
        randomness: RandomNumberGenerator = RandomnessSource()
    ) -> (min: Damage, max: Damage) {
        
        let attackingHero = attackingStack.controllingHero
        let attack = attackingStack.totalAttack
        let defense = targetStack.totalDefense
        
        let isRangedAttack = attackType.isRanged
        let isMeleeAttack = attackType.isMelee
        
        let DMGb: Damage = {
            let minDamage = attackingStack.creatureType.stats.damage.minumumDamage
            guard !attackingStack.isCursed else { // This is NOT a sustainable solution.
                return minDamage
            }
            let maxDamage = attackingStack.creatureType.stats.damage.maximumDamage
            
            let ten = 10
            let averageRandom = ((0..<ten).map { _ -> Void in }).map {
                Damage.random(in: minDamage...maxDamage)
            }.reduce(0, +)
            
            // If there are less than or equal to 10 creatures in a stack then a random integer is chosen in a damage range for each creature, and they are added up.
            guard attackingStack.currentQuantity > ten else{ return averageRandom }
            
            // If there are more than 10 creatures in a stack, 10 random integers are chosen in a damage range of the creature and added up. The result is multiplied by N/10, where N is the number of creatures in the stack, and rounded down.
            return Damage(
                floor(
                    Double(averageRandom) * (Double(attackingStack.currentQuantity) / Double(ten))
                )
            )
        }()
        
        let I1: Double = {
            guard attack > defense else { return 0 }
            return 0.05 * (Double(attack - defense))
        }()
        
        let R1: Double = {
            guard defense > attack else { return 0 }
            return 0.025 * (Double(defense - attack))
        }()
        
        let I2: Double = {
            guard let attackingHero = attackingHero else { return 0 }
            if isRangedAttack {
                guard let archeryLevel = attackingHero.level(of: .archery) else {
                    return 0
                }
                let rangedMultiplier: Double
                switch archeryLevel {
                case .basic: rangedMultiplier = 0.10
                case .advanced: rangedMultiplier = 0.25
                case .expert: rangedMultiplier = 0.50
                default: fatalError("unknown skill level") // This is NOT sustainable
                }
                return rangedMultiplier
            } else {
                guard let offenseLevel = attackingHero.level(of: .offense) else {
                    return 0
                }
                let meleeMultiplier: Double
                switch offenseLevel {
                case .basic: meleeMultiplier = 0.10
                case .advanced: meleeMultiplier = 0.20
                case .expert: meleeMultiplier = 0.30
                default: fatalError("unknown skill level") // This is NOT sustainable
                }
                return meleeMultiplier
            }
        }()
        
        let I3: Double = {
            guard let attackingHero = attackingHero else { return 0 }
            
            // Orrin and Gundula has Hero speciality `Archery`
            // Crag Hack Hero specialty "Offense"
            if
                attackingHero.hasSpecialty(skill: .offense) && isMeleeAttack
                    ||
                    attackingHero.hasSpecialty(skill: .archery) && isRangedAttack
            {
                return 0.05 * I2 * Double(attackingHero.level)
            } else if attackingHero.hasSpecialty(spell: .bless) && attackingStack.isBlessed {
                // special case Adela's bless
                return 0.03 * (Double(attackingHero.level) / Double(attackingStack.creatureType.tier) )
            } else {
                return 0
            }
        }()
        
        // Luck modifier
        let I4: Double = {
            // The luck variable may be either 0 or 1.00,
            // depending on whether or not the attacking
            // creatures gets "a lucky strike". This is
            // determined by the combat variable luck,
            // which may be 0 (neutral),
            // +1 (positive), +2 (good) or +3 (excellent).
            // These values determine how often lucky
            // strikes occur. These probabilities are,
            // respectively, 0/24 (0%), 1/24 (4.17%),
            // 1/12 (8.33%) and 1/8 (12.5%). Luck may
            // be affected by artifacts, adventure map
            // locations, spells and the Luck secondary skill.
            
            let gotLucky = false
            return gotLucky ? 1 : 0
        }()
        
        let I5: Double = 1
        let R2: Double = 1
        let R3: Double = 1
        let R4: Double = 1
        let R5: Double = 1
        let R6: Double = 1
        let R7: Double = 1
        let R8: Double = 1
        let DMGf = Double(DMGb) * (1 + I1 + I2 + I3 + I4 + I5) * (1 - R1) * (1 - R2 - R3) * (1 - R4) * (1 - R5) * (1 - R6) * (1 - R7) * (1 - R8)
        
        // TODO calc min, max
        return (min: 0, max: Damage(DMGf))
    }
}

// MARK: Public
public extension Combat.CreatureStack {
    typealias SelfC = Combat.CreatureStack
    typealias Quantity = UInt
    typealias Damage = Creature.Stats.HealthPoints
    
    var isWounded: Bool {
        inflictedDamage != nil
    }
    
    var canBeResurrectedOrAnimated: Bool {
        perishedQuanity > 0
    }
    
    @discardableResult
    func resurrectOrAnimateDead(_ quantity: Quantity) -> SelfC {
        precondition(quantity <= perishedQuanity)
        perishedQuanity -= quantity
        currentQuantity += quantity
        return self
    }
    
    @discardableResult
    func inflictDamage(_ damage: Damage) -> SelfC {
        if damage >= healthPointsOfCurrentDefender {
            let damageToInflictOnNextGuy = Int(damage) - Int(healthPointsOfCurrentDefender)
            assert(damageToInflictOnNextGuy >= 0)
            
            defer {
                let killCount = Quantity(Double(damageToInflictOnNextGuy) / Double(creatureHealthPoints))
                kill(killCount)
            }
            
            let newInflictedDamageAsInt: Int = Int(healthPointsOfCurrentDefender) - Int(damage)
            inflictedDamage = Damage(abs(newInflictedDamageAsInt))
        } else {
            // wound
            inflictedDamage += damage
        }
        
        return self
    }
    
    @discardableResult
    func kill(_ quantityPossiblyGreaterThanStackCount: Quantity) -> SelfC {
        let quantity = min(quantityPossiblyGreaterThanStackCount, currentQuantity)
        currentQuantity -= quantity
        perishedQuanity += quantity
        return self
    }
    
    func attack(_ targetStack: SelfC) {
        fatalError()
    }
    
    func damageInterval(
        whenAttackin targetStack: SelfC,
        type attackType: AttackType
    ) -> (min: Damage, max: Damage) {
        
        Self.calculateDamageInterval(
            causedBy: self,
            attacking: targetStack,
            attackType: attackType
        )
    }
    
}

// MARK: HasSpell
public extension Combat.CreatureStack {
    
    var activeSpells: [Spell] {
        modifiers.compactMap({ $0 as? Spell })
    }
    
    var isCursed: Bool {
        hasActiveSpell(.curse)
    }
    
    var isBlessed: Bool {
        hasActiveSpell(.bless)
    }
    
    func hasActiveSpell(_ spell: Spell) -> Bool {
        activeSpells.contains(spell)
    }
    
    func isAffected<M>(by modifier: M) -> Bool where M: Modifier & Equatable {
        modifiers.compactMap({ $0 as? M }).contains(modifier)
    }
}

// MARK: Codable
public extension Combat.CreatureStack {
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
