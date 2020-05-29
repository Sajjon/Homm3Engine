//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import XCTest
@testable import HoMM3Engine


final class SimpleCombatTests: XCTestCase {
    
    func testSimpleCombat() throws {
        let solmyr🔴 = Hero.solmyr(ownedBy: .red)
        let redArmy🔴 = Army(hero: solmyr🔴)
            .add(creatureStack: BlackDragon.stack(of: 3))
        
        let serena🔵 = Hero.serena(ownedBy: .blue)
        let blueArmy🔵 = Army(hero: serena🔵)
            .add(creatureStack: RedDragon.stack(of: 5))

        let battlefield = Battlefield(terrain: .grass)
        
        let encounter = Encounter(
            betweenAttacker: redArmy🔴,
            defender: blueArmy🔵,
            on: battlefield
        )
        
        let a0: Combat.CreatureStack.Tag = 1
        let d0: Combat.CreatureStack.Tag = 2
//        let tagToStackMap: Combat.CreatureStackTagMapping = [
//            a0:
//        ]
        
        let report = try encounter.startCombat(
            { attackingArmy, defendingArmy in
                return [
                    a0: attackingArmy.creatureStacks[0],
                    d0: defendingArmy.creatureStacks[0]
                ]
            },
            { combat in
                let as0 = combat.stack(tag: a0)
                XCTAssertEqual(as0.creatureType, BlackDragon)
                XCTAssertEqual(as0.quantity, 3)
                let ds0 = combat.stack(tag: d0)
                XCTAssertEqual(ds0.creatureType, RedDragon)
                XCTAssertEqual(ds0.quantity, 5)
               
                try combat.perform(action: .move(stack: as0, to: .rAcE, attack: .init(ds0)))
                
                return .retreated
        })

//        while !combat.isFinished {
//            combat.perform(action: .move(stack: combat.attacker., to: <#T##Battlefield.HexTile#>, attack: <#T##Combat.Action.StackAttack?#>))
//            let action = Combat.Action.move(
//                stack: redArmy🔴.creatureStacks[0],
//                to: Battlefield.HexTile(row: 1, column: 13),
//                attack: blueArmy🔵.creatureStacks[0]
//            )
//            combat.let(, perform: <#T##Combat.Action#>)
            
//        }
        
//
//        let (minDamage, maxDamage) = blackDragons.damageInterval(
//            whenAttackin: redDragons,
//            type: .melee
//        )
//
//        XCTAssertEqual(minDamage, 1)
//        XCTAssertEqual(maxDamage, 10)
        
//        let attackingArmy = Army.init(hero: solmyr🔴, creatureStacks: [])
        
//        Battle.between(attacker: <#T##Army#>, andDefender: <#T##Army#>)
    }

}

