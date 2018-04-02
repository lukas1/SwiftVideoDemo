import XCTest
@testable import VideoPlayerDemo

class VideoRangesTests: XCTestCase {

    func testParseRangesWithInvalidInputs() {
        XCTAssertEqual([], parseRange(input: ""))
        XCTAssertEqual([], parseRange(input: "dsjgklsdjgls"))
        XCTAssertEqual([], parseRange(input: "(02, 0);(, 1)"))
        XCTAssertEqual([], parseRange(input: "(1.2, 1.4);(1.6, 1.8)"))
    }

    func testParseRangesWithPartiallyInvalidInput() {
        XCTAssertEqual([0.6..<0.8], parseRange(input: "(1.2, 1.4);(0.6, 0.8)"))
    }

    func testParseRanges() {
        let expected: Array<Range<Double>> = [
            0.2..<0.4,
            0.6..<0.8
        ]
        XCTAssertEqual(expected, parseRange(input: "(0.2, 0.4);(0.6, 0.8)"))
    }

    func testSortVideoRanges() {
        let input: Array<Range<Double>> = [
            0.6..<0.8,
            0.5..<0.6,
            0.2..<0.4
        ]

        let expected: Array<Range<Double>> = [
            0.2..<0.4,
            0.5..<0.6,
            0.6..<0.8
        ]

        XCTAssertEqual(expected, sortVideoRanges(input: input))
    }

    func testUniteOverlappingRanges() {
        let input: Array<Range<Double>> = [
            0.2..<0.4,
            0.3..<0.5,
            0.6..<0.8
        ]

        let expected: Array<Range<Double>> = [
            0.2..<0.5,
            0.6..<0.8
        ]

        XCTAssertEqual(expected, uniteOverlappingRanges(sortedRanges: input))
    }
}

