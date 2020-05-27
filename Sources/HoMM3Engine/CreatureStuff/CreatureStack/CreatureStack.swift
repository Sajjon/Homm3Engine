//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

public struct CreatureStack {
    
    //    public private(set) var state: State
    public private(set) var creatureType: Creature
    private let startingQuantity: Quantity
    private var currentQuantity: Quantity
    private var perishedQuanity: Quantity = 0
    public let controllingHero: Hero
    public private(set) var inflictedDamage: Damage?
    
    /// E.g. spells
    public private(set) var modifiers = [Modifier]()
    
    public init(of creatureType: Creature, quantity: Quantity, controlledBy hero: Hero) {
        self.creatureType = creatureType
        self.startingQuantity = quantity
        self.currentQuantity = quantity
        self.controllingHero = hero
    }
}

internal extension Creature {
    func stack(of quantity: CreatureStack.Quantity, controlledBy hero: Hero) -> CreatureStack {
        .init(of: self, quantity: quantity, controlledBy: hero)
    }
}

// MARK: Private
private extension CreatureStack {
    
    typealias HPModifier = Creature.Stats.HealthPoints.Magnitude
    
    var creatureHPModifier: Creature.Stats.HealthPoints.Magnitude {
        return 1 // future: look through `self.modifiers`
    }
    
    var creatureHealthPoints: Creature.Stats.HealthPoints {
        creatureHPModifier * creatureType.stats.healthPoints
    }
    
    var healthPointsOfCurrentDefender: Creature.Stats.HealthPoints {
        let apa = creatureHealthPoints - inflictedDamage
        assert(apa > 0)
        return apa
    }
    
    /// Attack modifier, primarily the Hero's attack strength + spells
    var attackModifier: Creature.Stats.Attack {
//        var attackModifier = controllingHero.primarySkills.attack
//        if hasSpell(.bloodlust) {
//            attackModifier += 3 // or 6 if Hero has advanced / expert Fire Magic
//            // This is NOT a sustainable solution
//        }
//        if isAffected(by: AnyTrait.disease) {
//            attackModifier -= 2
//        }
//
//        // take into consideration: "native terrain or hero's creature specialties."
//        return attackModifier
        fatalError()
    }
    
    /// Creatures attack + modifier, primarily the Hero's attack strength
    var totalAttack: Creature.Stats.Attack {
        creatureType.stats.attack + attackModifier
    }
    
    /// Defense modifier, primarily the Hero's defense strength + spells
    var defenseModifier: Creature.Stats.Defense {
        var defenseModifier = controllingHero.primarySkills.defense
        if isAffected(by: AnyTrait.disease) {
            // This is NOT a sustainable solution
            defenseModifier -= 2
        }
        
        // take into consideration: "native terrain or hero's creature specialties."
        return defenseModifier
    }
    
    /// Creatures attack + modifier, primarily the Hero's attack strength
    var totalDefense: Creature.Stats.Defense {
        creatureType.stats.defense + defenseModifier
    }
    
    /// https://heroes.thelazy.net/index.php/Damage#The_damage_calculation_formula
    static func calculateDamage(causedBy attackingStack: Self, attacking targetStack: Self) -> Damage {
        let attackingHero = attackingStack.controllingHero
        let attack = attackingStack.totalAttack
        let defense = targetStack.totalDefense
        let isRangedAttack = false
        
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
//            guard attack > defense else { return 0 }
//            return 0.05 * (Double(attack - defense))
            fatalError()
        }()
        
        let R1: Double = {
//            guard defense > attack else { return 0 }
//            return 0.025 * (Double(defense - attack))
            fatalError()
        }()
        
        let I2: Double = {
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
        
        let I3: Double = 1
        let I4: Double = 1
        let I5: Double = 1
        let R2: Double = 1
        let R3: Double = 1
        let R4: Double = 1
        let R5: Double = 1
        let R6: Double = 1
        let R7: Double = 1
        let R8: Double = 1
        let DMGf = Double(DMGb) * (1 + I1 + I2 + I3 + I4 + I5) * (1 - R1) * (1 - R2 - R3) * (1 - R4) * (1 - R5) * (1 - R6) * (1 - R7) * (1 - R8)
        return Damage(DMGf)
    }
}

// MARK: Public
public extension CreatureStack {
    typealias Quantity = UInt
    typealias Damage = Creature.Stats.HealthPoints
    
    var isWounded: Bool {
        inflictedDamage != nil
    }
    
    var canBeResurrectedOrAnimated: Bool {
        perishedQuanity > 0
    }
    
    @discardableResult
    mutating func resurrectOrAnimateDead(_ quantity: Quantity) -> Self {
        precondition(quantity <= perishedQuanity)
        perishedQuanity -= quantity
        currentQuantity += quantity
        return self
    }
    
    @discardableResult
    mutating func inflictDamage(_ damage: Damage) -> Self {
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
    mutating func kill(_ quantityPossiblyGreaterThanStackCount: Quantity) -> Self {
        let quantity = min(quantityPossiblyGreaterThanStackCount, currentQuantity)
        currentQuantity -= quantity
        perishedQuanity += quantity
        return self
    }
    
    mutating func attack(_ targetStack: inout Self) {
//        fatalError()
    }
    
    
}

// MARK: HasSpell
public extension CreatureStack {
    
    var activeSpells: [Spell] {
        modifiers.compactMap({ $0 as? Spell })
    }
    
    var isCursed: Bool {
        hasSpell(.curse)
    }
    
    func hasSpell(_ spell: Spell) -> Bool {
        activeSpells.contains(spell)
    }
    
    func isAffected<M>(by modifier: M) -> Bool where M: Modifier & Equatable {
        modifiers.compactMap({ $0 as? M }).contains(modifier)
    }
}
