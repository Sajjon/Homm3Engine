//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-25.
//

import XCTest
@testable import HoMM3Engine

final class SimpleCombatTests: XCTestCase {
    
    
    func testSimpleCombat() {
        let solmyr🔴 = Hero.solmyr(ownedBy: .red)
        let serena🔵 = Hero.serena(ownedBy: .blue)
        
        let blackDragons = BlackDragon.stack(of: 3, controlledBy: solmyr🔴)
        let redDragons = RedDragon.stack(of: 5, controlledBy: serena🔵)
        
        let (minDamage, maxDamage) = blackDragons.damageInterval(
            whenAttackin: redDragons,
            type: .melee
        )
        
        XCTAssertEqual(minDamage, 1)
        XCTAssertEqual(maxDamage, 10)
        
//        let attackingArmy = Army.init(hero: solmyr🔴, creatureStacks: [])
        
//        Battle.between(attacker: <#T##Army#>, andDefender: <#T##Army#>)
    }

}

