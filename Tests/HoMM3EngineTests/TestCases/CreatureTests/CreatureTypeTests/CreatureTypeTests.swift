//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import XCTest
@testable import HoMM3Engine

final class CreatureTypeTests: XCTestCase {
    
    func testRedBlackDragonShareSameBaseType() {
        XCTAssertTrue(RedDragon.sameBase(as: BlackDragon))
        XCTAssertTrue(BlackDragon.sameBase(as: RedDragon))
        
        XCTAssertTrue(RedDragon.sameBase(as: RedDragon))
        XCTAssertTrue(BlackDragon.sameBase(as: BlackDragon))
    }
    
    func testNameOfRedDragon() {
        XCTAssertEqual(RedDragon.displayName, "Red Dragon")
    }
    
    func testNameOfBlackDragon() {
        XCTAssertEqual(BlackDragon.displayName, "Black Dragon")
        XCTAssertEqual(BlackDragon.uniqueName, "blackDragon")
    }
    
    func testIsUpgradeOf() throws {
        XCTAssertFalse(RedDragon.isUpgrade(of: RedDragon))
        XCTAssertFalse(RedDragon.isUpgrade(of: BlackDragon))

        XCTAssertTrue(BlackDragon.isUpgrade(of: RedDragon))
        XCTAssertFalse(BlackDragon.isUpgrade(of: BlackDragon))
        
        XCTAssertNil(BlackDragon.upgrade)
        XCTAssertNotNil(RedDragon.upgrade)
        
        let upgradeOfRedDragon = try XCTUnwrap(RedDragon.upgrade)
        XCTAssertEqual(upgradeOfRedDragon, BlackDragon)
    }
    
}
