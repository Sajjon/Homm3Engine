//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import Foundation

// MARK: CreatureTraitsLedger
public final class CreatureUpgradesLedger {
    public static let shared = CreatureUpgradesLedger()
    private var upgradedCreatureOf: [Creature: Creature] = [:]
}

public extension CreatureUpgradesLedger {
    static func mark(
        creature upgradedCreature: Creature,
        asUpgradeOf baseCreature: Creature
    ) {
        shared.mark(creature: upgradedCreature, asUpgradeOf: baseCreature)
    }
    
    static func assertNonUpgradedCreatureIsUnique(_ supposedlyNewBaseCreature: Creature) {
        shared.assertNonUpgradedCreatureIsUnique(supposedlyNewBaseCreature: supposedlyNewBaseCreature)
    }
    
    static func `is`(
        creature supposedlyBaseCreature: Creature,
        upgradeOf supposedlyUpgradedCreature: Creature
    ) -> Bool {
        shared.is(creature: supposedlyBaseCreature, upgradeOf: supposedlyUpgradedCreature)
    }
    
    static func upgradedCreature(of baseCreature: Creature) -> Creature? {
        shared.upgradedCreature(of: baseCreature)
    }
}

private extension CreatureUpgradesLedger {
    func mark(
        creature upgradedCreature: Creature,
        asUpgradeOf baseCreature: Creature
    ) {
        precondition(upgradedCreatureOf[upgradedCreature] == nil)
        upgradedCreatureOf[upgradedCreature] = baseCreature
        precondition(upgradedCreatureOf[upgradedCreature] != nil)
    }
    
    func assertNonUpgradedCreatureIsUnique(supposedlyNewBaseCreature: Creature) {
        assert(upgradedCreatureOf.keys.contains(supposedlyNewBaseCreature) == false)
    }
    
    func `is`(
        creature supposedlyBaseCreature: Creature,
        upgradeOf supposedlyUpgradedCreature: Creature
    ) -> Bool {
        upgradedCreatureOf[supposedlyBaseCreature] == supposedlyUpgradedCreature
    }
    
    func upgradedCreature(of baseCreature: Creature) -> Creature? {
        for (key, value) in upgradedCreatureOf {
            if value == baseCreature {
                return key
            }
        }
        return nil
    }
}

