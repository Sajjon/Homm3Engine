import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HeroesOfMightAndMagic3Tests.allTests),
    ]
}
#endif
