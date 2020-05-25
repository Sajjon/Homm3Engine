//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import XCTest
@testable import HoMM3Engine

final class TraitTests: XCTestCase {
    
    func testAddingTraits() {
        XCTAssertTrue(RedDragon.hasTrait(.breathAttack))
        XCTAssertFalse(RedDragon.hasTrait(.noEnemyRetaliation))
        RedDragon.addTrait(.noEnemyRetaliation)
        XCTAssertTrue(RedDragon.hasTrait(.noEnemyRetaliation))
    }
    
    func testNegationOfTraits() {
        XCTAssertTrue(Battlefield.Trait.obstacle.isNegated︖(by: AnyTrait.flying))
        XCTAssertFalse(AnyTrait.flying.isNegated︖(by: Battlefield.Trait.obstacle))
            
        XCTAssertFalse(Battlefield.Trait.obstacle.isNegating︖(AnyTrait.flying))
        XCTAssertTrue(AnyTrait.flying.isNegating︖(Battlefield.Trait.obstacle))
    }
}
