import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HoMM3EngineTests.allTests),
    ]
}
#endif
