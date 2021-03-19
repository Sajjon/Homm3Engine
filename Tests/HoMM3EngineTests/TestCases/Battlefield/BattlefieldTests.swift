//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-12-02.
//

import XCTest
import HoMM3Engine

public class TestCase: XCTestCase {
    public override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}

public final class BattlefieldTests: XCTestCase {

    // MARK: Distance Tests
    func test_distance_from_r0c0_to_r0c0_is_zero() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r0c0
            ),
            0
        )
    }
    
    func test_distance_from_r0c0_to_r0c1_is_one() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r0c1
            ),
            1
        )
    }
    
    func test_distance_from_r0c0_to_r0c2_is_two() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r0c2
            ),
            2
        )
    }
    
    func test_distance_from_r0c0_to_r0c3_is_three() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r0c3
            ),
            3
        )
    }
    
    
    func test_distance_from_r0c0_to_r0cE_is_fourteen() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r0cE
            ),
            14
        )
    }
    
    func test_distance_from_r0c0_to_r1c0_is_one() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r1c0
            ),
            1
        )
    }
    
    func test_distance_from_r0c0_to_r1c1_is_one() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r1c1
            ),
            1
        )
    }
    
    func test_distance_from_r0c0_to_r1c2_is_two() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r1c2
            ),
            2
        )
    }
    
    func test_distance_from_r0c0_to_r1c3_is_three() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r1c3
            ),
            3
        )
    }
    
    
    func test_distance_from_r0c0_to_r2c0_is_two() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r2c0
            ),
            2
        )
    }
    
    func test_distance_from_r5c6_to_r5c7_is_one() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r5c6,
                and: .r5c7
            ),
            1
        )
    }
    
    
    func test_distance_from_r4c6_to_r5c7_is_one() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r4c6,
                and: .r5c7
            ),
            1
        )
    }
    
    func test_distance_from_r0c13_to_adjacent_its_tiles_is_1() {
        assertThatDistances(
            from: .r0cD,
            to: [.r0cC, .r1cD, .r1cE, .r0cE],
            allEqual: 1
        )
    }
    
    func test_distance_from_r2c2_to_r6c6_is_six() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r2c2,
                and: .r6c6
            ),
            6
        )
    }
    
    
    func test_distance_from_r0c0_to_r2c4_is_five() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r2c4
            ),
            5
        )
    }
    
    func test_distance_from_r0c0_to_r4c4_is_six() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r4c4
            ),
            6
        )
    }
    
    
    
    func test_distance_from_r0c0_to_r6c4_is_seven() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .r6c4
            ),
            7
        )
    }
    
    
    
    func test_distance_from_r1c0_to_r0c4_is_five() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r1c0,
                and: .r0c4
            ),
            5
        )
    }
    
    func test_all_equal_five() {
        assertThatDistances(
            from: .r1c0,
            to: [.r0c4, .r1c5, .r2c4, .r3c4, .r4c3, .r5c3, .r6c2, .r6c1, .r6c0],
            allEqual: 5
        )
    }
    
    
    
    
    
    func test_distance_from_r2c2_to_r6c7_is_seven() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r2c2,
                and: .r6c7
            ),
            7
        )
    }
    
    func test_distance_from_r2c2_to_r6c8_is_eight() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r2c2,
                and: .r6c8
            ),
            8
        )
    }
    
    
    func test_distance_from_r2c2_to_r4cE_is_thirteen() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r2c2,
                and: .r4cE
            ),
            13
        )
    }
    
    
    func test_distance_from_r2c2_to_r6cE_is_fourteen() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r2c2,
                and: .r6cE
            ),
            14
        )
    }
    
    
    func test_distance_from_r0c0_to_rAcE_is_nineteen() {
        let battlefield = Battlefield()
        XCTAssertEqual(
            battlefield.distance(
                between: .r0c0,
                and: .rAcE
            ),
            19
        )
    }
    
    func test_distance_from_r5c7_to_adjacent_its_tiles_is_1() {
        assertThatDistances(
            from: .r5c7,
            to: [.r4c6, .r4c7, .r5c6, .r5c8, .r6c6, .r6c7],
            allEqual: 1
        )
    }
}

private extension BattlefieldTests {
    func assertThatDistances(
        from sourceTile: Battlefield.HexTile,
        to destinationsTiles: [Battlefield.HexTile],
        allEqual expectedDistance: Battlefield.HexTile.Value,
        on battlefield: Battlefield = .init(),
        line: UInt = #line
    ) {
        destinationsTiles.enumerated().forEach { (destinationTileIndex, destinationTile) in
            let calculatedDistance = battlefield.distance(
                between: sourceTile,
                and: destinationTile
            )
            XCTAssertEqual(
                calculatedDistance,
                expectedDistance,
                "Expected distance between: \(sourceTile.name) and \(destinationTile.name) is \(expectedDistance), but got: \(calculatedDistance) (destinationTileIndex: \(destinationTileIndex)",
                line: line
            )
        }
    }
}
