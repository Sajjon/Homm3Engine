//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import XCTest
@testable import HoMM3Engine

final class CreatureMovementTypeTests: XCTestCase {
        
        func testRedDragonCanFly() {
            XCTAssertTrue(RedDragon.canFly)
        }
    
        func testBlackDragonCanFly() {
            XCTAssertTrue(BlackDragon.canFly)
        }
    
}
