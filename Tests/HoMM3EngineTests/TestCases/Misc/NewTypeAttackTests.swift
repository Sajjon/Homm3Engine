//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-27.
//

import XCTest
@testable import HoMM3Engine

final class NewTypeAttackTests: XCTestCase {
    
    private let a: Attack = 8
    private let b: Attack = 5
    
    func testAddition() {
        XCTAssertEqual(a + b, 13)
    }
    
    func testMultiplication() {
        XCTAssertEqual(a * b, 40)
    }
    
    func testSubtaction() {
        XCTAssertEqual(a - b, 3)
    }
    
    func testConvertToModifier() {
        let attack: Attack = 42
        let combatModifier = CombatModifier(attack)
        XCTAssertEqual(combatModifier, 42)
        XCTAssertEqual(attack.toCombatModifier(), 42)
    }
    
    func testStride() {
        let from: Attack = 10
        let to: Attack = 40
        let stride = Swift.stride(from: from, to: to, by: 10)
        let array = [Attack](stride)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array, [10, 20, 30])
    }
    
    // MARK: FixedWidthInteger
    func testDividingFullWidth() {
        
        // SANITY using UInt
        let (uintQ, uintR) = UInt(2241543570477705381).dividingFullWidth((22640526660490081, 7959093232766896457 as UInt))
        XCTAssertEqual(uintQ, 186319822866995413)
        XCTAssertEqual(uintR, 0)
        
        let (aQ, aR) = Attack(2241543570477705381).dividingFullWidth((Attack(22640526660490081), 7959093232766896457))
        XCTAssertEqual(aQ, Attack(186319822866995413))
        XCTAssertEqual(aR, 0)
    }
    
    // MARK: UnsignedInteger
    func testUnsignedIntegerMagnitude() {
        // SANITY using UInt
        XCTAssertEqual(UInt(123457).magnitude as UInt, 123457)
        
        XCTAssertEqual(Attack(123457).magnitude as Attack, 123457)
    }

}
