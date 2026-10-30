import XCTest
@testable import PlaymezEmbed

final class PlaymezEventTests: XCTestCase {
    func testParsesResult() throws {
        let e = try XCTUnwrap(PlaymezEvent(json: #"{"source":"spinline","type":"result","game":"LUDO","won":true,"net":40}"#))
        XCTAssertEqual(e.type, "result")
        XCTAssertEqual(e.game, "LUDO")
        XCTAssertTrue(e.won)
        XCTAssertEqual(e.net, 40)
    }

    func testRejectsOtherSendersAndMalformed() {
        XCTAssertNil(PlaymezEvent(json: #"{"source":"other","type":"result"}"#))
        XCTAssertNil(PlaymezEvent(json: #"{"source":"spinline"}"#))
        XCTAssertNil(PlaymezEvent(json: "not json"))
        XCTAssertNil(PlaymezEvent(body: [1, 2]))
    }

    func testExposesErrorAndResizeFields() throws {
        XCTAssertEqual(try XCTUnwrap(PlaymezEvent(json: #"{"source":"spinline","type":"error","code":"LAUNCH_USED","message":"used"}"#)).code, "LAUNCH_USED")
        XCTAssertEqual(try XCTUnwrap(PlaymezEvent(json: #"{"source":"spinline","type":"resize","height":720}"#)).height, 720)
    }

    func testExposesLocalFinish() throws {
        let e = try XCTUnwrap(PlaymezEvent(json: #"{"source":"spinline","type":"local_finished","game":"chess","draw":false,"won":true}"#))
        XCTAssertEqual(e.type, "local_finished")
        XCTAssertEqual(e.game, "chess")
        XCTAssertEqual(e.wonVsComputer, true)
        let together = try XCTUnwrap(PlaymezEvent(json: #"{"source":"spinline","type":"local_finished","game":"ludo","draw":true,"won":null}"#))
        XCTAssertTrue(together.draw)
        XCTAssertNil(together.wonVsComputer)
    }

    func testVersionIsSet() {
        XCTAssertTrue(playmezSdkVersion.range(of: #"^\d+\.\d+\.\d+"#, options: .regularExpression) != nil)
    }
}
