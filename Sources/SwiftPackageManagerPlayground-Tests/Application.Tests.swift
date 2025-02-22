import XCTest
@testable import Playground

final class Application_Tests: XCTestCase {
    func testApplication() async {
        let sut = Something()
        let executionContext = MockExecutionContext()
        sut.mainExecutionContext = executionContext
        
        await sut.makeUpdates()
        await MainActor.run { executionContext.mockExecute?() }
        XCTAssert(sut.count == 1)
    }
}
