import XCTest
@testable import HoMM3Engine

final class HoMM3EngineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HoMM3Engine().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
