//
//  File.swift
//
//
//  Created by Alexander Cyon on 2020-05-27.
//

import XCTest
@testable import HoMM3Engine

final class NewTypeDefenseTests: XCTestCase {
    
    private let a: Defense = 8
    private let b: Defense = 5
    
    func testAddition() {
        XCTAssertEqual(a + b, 13)
    }
    
    func testMultiplication() {
        XCTAssertEqual(a * b, 40)
    }
    
    func testSubtaction() {
        XCTAssertEqual(a - b, 3)
    }
    
    func testStride() {
        let from: Defense = 10
        let to: Defense = 40
        let stride = Swift.stride(from: from, to: to, by: 10)
        let array = [Defense](stride)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array, [10, 20, 30])
    }
    
    func testAddDefenseAndAttackIsError() {
        XCTAssertTrue(UInt.self == UInt.self)
        XCTAssertFalse(Int.self == UInt.self)
        
        XCTAssertTrue(Defense.self == Defense.self)
        XCTAssertFalse(Defense.self == UInt.self)
        XCTAssertFalse(Defense.self == Attack.self)
    }
    
    func testConvertToModifier() {
        let attack: Defense = 42
        let combatModifier = CombatModifier(attack)
        XCTAssertEqual(combatModifier, 42)
        XCTAssertEqual(attack.toCombatModifier(), 42)
    }
    
    func testAddDefenseAndAttackThanksToSharedProtocol() {
        let attack: Attack = 5
        let defense: Defense = 3
        XCTAssertEqual(attack + defense, 8)
        XCTAssertEqual(attack + CombatModifier(3), 8)
        XCTAssertEqual(CombatModifier(5) + defense, 8)
    }
    
    func testMultDefenseAndAttackThanksToSharedProtocol() {
        let attack: Attack = 5
        let defense: Defense = 3
        XCTAssertEqual(attack * defense, 15)
        XCTAssertEqual(attack * CombatModifier(3), 15)
        XCTAssertEqual(CombatModifier(5) * defense, 15)
        
        XCTAssertEqual(attack * CombatModifier(-1), -5)
    }
    
    func testCombatModifierToAttack() {
        let combatModifier: CombatModifier = 5
        XCTAssertEqual(Attack(combatModifier), 5)
    }
    
    func testCombatModifierToDefense() {
        let combatModifier: CombatModifier = 5
        XCTAssertEqual(Defense(combatModifier), 5)
    }

}

