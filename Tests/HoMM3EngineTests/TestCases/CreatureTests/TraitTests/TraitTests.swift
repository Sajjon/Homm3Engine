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
        let noEneRet = AnyTrait.noEnemyRetaliation
        XCTAssertTrue(RedDragon.hasTrait(Traits.breathAttack))
        XCTAssertFalse(RedDragon.hasTrait(noEneRet))
        RedDragon.addTrait(noEneRet)
        XCTAssertTrue(RedDragon.hasTrait(Traits.noEnemyRetaliation))
    }
}
