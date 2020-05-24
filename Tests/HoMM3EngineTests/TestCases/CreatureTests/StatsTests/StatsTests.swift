//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-05-24.
//

import XCTest
@testable import HoMM3Engine

final class StatsTest: XCTestCase {
    func testRedBlackDragonHP() {
        XCTAssertEqual(RedDragon.stats.healthPoints, 180)
        XCTAssertEqual(BlackDragon.stats.healthPoints, 300)
    }
}
