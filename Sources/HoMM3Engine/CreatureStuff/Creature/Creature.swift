//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import Foundation

// MARK: Creature
public struct Creature: Hashable, Codable, CustomStringConvertible {
    
    /// This is what  groups together a red dragon and a black dragon, this value is the
    /// same for both of these creatures. The name of the creature is defined by
    /// the property `uniqueName`
    private let idSharedForAllLevelsOfUpgrades: CamelCasedStringAaZz
    
    /// This is what uniqueley identifies this creature type, a red dragon != a black dragon, because of this value that separates
    /// the non upgraded and the upgraded version, however they will have the same value  of the
    /// property `idSharedForAllLevelsOfUpgrades`
    public let uniqueName: CamelCasedStringAaZz
    
    /// This is the displayed name, ought be `"Black Dragon"` instead of `"blackDragon"`, having a
    /// `idSharedForAllLevelsOfUpgrades` value of `redDragon` (shared with the red dragon).
    public let displayName: String
    
    public let tier: Tier
    public let faction: Faction
    public let stats: Stats
    
    private init(
        idSharedForAllLevelsOfUpgrades: CamelCasedStringAaZz,
        displayName: String,
        uniqueName: CamelCasedStringAaZz? = nil, // will use camelCased version of `displayName` if nil
        faction: Faction,
        tier: Tier,
        stats: Stats,
        upgradeOf baseCreature: Self? = nil
    ) {
        defer {
            if let baseCreature = baseCreature {
                CreatureUpgradesLedger.mark(creature: self, asUpgradeOf: baseCreature)
            } else {
                CreatureUpgradesLedger.assertNonUpgradedCreatureIsUnique(self)
            }
        }
        self.idSharedForAllLevelsOfUpgrades = idSharedForAllLevelsOfUpgrades
        self.displayName = displayName
        self.uniqueName = uniqueName ?? .init(camelCasing: displayName)
        self.faction = faction
        self.tier = tier
        self.stats = stats
    }
}

// MARK: CustomStringConvertible
public extension Creature {
    var description: String { displayName }
}


// MARK: Creature + Equatable
public extension Creature {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uniqueName == rhs.uniqueName
    }
}

// MARK: Creature + Hashable
public extension Creature {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueName)
    }
}


// MARK: Creation
public extension Creature {
    
    static func declareNonUpgraded(
        named: String,
        faction: Faction,
        tier: Tier,
        stats: Stats
    ) -> Self {
        .init(
            idSharedForAllLevelsOfUpgrades: .init(camelCasing: named),
            displayName: named,
            faction: faction,
            tier: tier,
            stats: stats
        )
    }
    
    func upgraded(
        named upgradedName: String,
        _ rawBaseName: String = #function,
        _ modifyStats: (Stats) -> Stats
    ) -> Self {

        .init(
            idSharedForAllLevelsOfUpgrades: self.idSharedForAllLevelsOfUpgrades,
            displayName: upgradedName,
            faction: faction,
            tier: tier,
            stats: modifyStats(self.stats),
            upgradeOf: self
        )
    }
}

// MARK: Public
public extension Creature {
    
    func sameBase(as other: Self) -> Bool {
        idSharedForAllLevelsOfUpgrades == other.idSharedForAllLevelsOfUpgrades
    }
    
    @discardableResult
    func add<T>(trait: T) -> Self where T: Trait {
        CreatureTraitsLedger.addTrait(trait, to: self)
        return self
    }
    
    @discardableResult
    func addTrait(_ trait: AnyTrait) -> Self {
        add(trait: trait)
    }
    
    var traits: Set<AnyTrait> {
        CreatureTraitsLedger.traits(of: self)
    }
    
    func has<T>(trait: T) -> Bool where T: Trait {
        hasTrait(trait.eraseToAnyTrait())
    }
    
    func hasTrait(_ trait: AnyTrait) -> Bool {
        CreatureTraitsLedger.does(creature: self, haveTrait: trait)
    }
    
    func isUpgrade(of creature: Creature) -> Bool {
        guard faction == creature.faction else { return false }
        guard tier == creature.tier else { return false }
        return CreatureUpgradesLedger.is(creature: self, upgradeOf: creature)
    }
    
    var upgrade: Self? {
        CreatureUpgradesLedger.upgradedCreature(of: self)
    }
}

// MARK: Query specific traits
public extension Creature {
    
    var canFly: Bool {
        hasTrait(.flying)
    }
}
