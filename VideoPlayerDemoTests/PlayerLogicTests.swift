import XCTest
import CoreMedia
@testable import VideoPlayerDemo

class PlayerPresenterTests: XCTestCase {    
    func testCalculateScrubberKnobXPosition() {
        XCTAssertEqual(0.0, calculateScrubberKnobXPosition(duration: 0, currentSeconds: 0, scrubberWidth: 0))
        XCTAssertEqual(24.0, calculateScrubberKnobXPosition(duration: 100, currentSeconds: 24, scrubberWidth: 100))
        XCTAssertEqual(50.0, calculateScrubberKnobXPosition(duration: 60, currentSeconds: 30, scrubberWidth: 100))
    }

    func testGetActiveScrubberZonesRectsWhenRangesAreEmpty() {
        let rect = CGRect(x: 1, y: 2, width: 10, height: 20)
        XCTAssertEqual([rect], getActiveScrubberZonesRects(scrubberRect: rect, videoRanges: []))
    }

    func testGetActiveScrubberZonesRectsWithWidth100() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 20)
        let ranges = [
            0.2..<0.4,
            0.5..<0.6,
            0.7..<0.8
        ]

        let expectedRects = [
            CGRect(x: 20, y: 0, width: 20, height: 20),
            CGRect(x: 50, y: 0, width: 10, height: 20),
            CGRect(x: 70, y: 0, width: 10, height: 20)
        ]
        
        testActiveScrubberZones(scrubberRect: rect, videoRanges: ranges, expectedRects: expectedRects)
    }

    func testGetActiveScrubberZonesRectsWithWidth150() {
        let rect = CGRect(x: 0, y: 0, width: 150, height: 20)
        let ranges = [
            0.2..<0.4,
            0.6..<0.8
        ]
        
        let expectedRects = [
            CGRect(x: 30, y: 0, width: 30, height: 20),
            CGRect(x: 90, y: 0, width: 30, height: 20)
        ]

        testActiveScrubberZones(scrubberRect: rect, videoRanges: ranges, expectedRects: expectedRects)
    }

    fileprivate func testActiveScrubberZones(scrubberRect: CGRect, videoRanges: Array<Range<Double>>, expectedRects: Array<CGRect>) {
        zip(expectedRects, getActiveScrubberZonesRects(scrubberRect: scrubberRect, videoRanges: videoRanges)).forEach { expected, actual in
            XCTAssert(fabs(expected.origin.x - actual.origin.x) < 1)
            XCTAssertEqual(expected.origin.y, actual.origin.y)
            XCTAssert(fabs(expected.width - actual.width) < 1)
            XCTAssertEqual(expected.height, actual.height)
        }
    }

    func testGetCMTimeRangeForPercentualPositionForEmptyRanges() {
        testGetCMTimeRangeForPercentualPositionInVideo(
            position: 0.1,
            expectedTimeRange: nil,
            ranges: []
        )
    }

    func testGetCMTimeRangeForPercentualPositionForEmptyVideo() {
        let ranges = [
            0.2..<0.4,
            0.6..<0.8
        ]

        XCTAssertEqual(
            CMTimeRange(start: CMTimeMakeWithSeconds(0, 1), end: CMTimeMakeWithSeconds(0, 1)),
            getCMTimeRangeForPercentualPositionInVideo(
                videoDuration: CMTimeMakeWithSeconds(0, 1), selectedPosition: 0.5, ranges: ranges
            )
        )
    }

    func testGetCMTimeRangeForPercentualPositionBeforeFirstRange() {
        let ranges = [
            0.2..<0.4,
            0.6..<0.8
        ]

        testGetCMTimeRangeForPercentualPositionInVideo(
            position: 0.1,
            expectedTimeRange: CMTimeRange(start: CMTimeMakeWithSeconds(20, 1), end: CMTimeMakeWithSeconds(40, 1)),
            ranges: ranges
        )
    }

    func testGetCMTimeRangeForPercentualPositionInFirstRange() {
        let ranges = [
            0.2..<0.4,
            0.6..<0.8
        ]
        
        testGetCMTimeRangeForPercentualPositionInVideo(
            position: 0.3,
            expectedTimeRange: CMTimeRange(start: CMTimeMakeWithSeconds(20, 1), end: CMTimeMakeWithSeconds(40, 1)),
            ranges: ranges
        )
    }

    func testGetCMTimeRangeForPercentualPositionAfterLastRange() {
        let ranges = [
            0.2..<0.4,
            0.6..<0.8
        ]
        
        testGetCMTimeRangeForPercentualPositionInVideo(
            position: 0.9,
            expectedTimeRange: CMTimeRange(start: CMTimeMakeWithSeconds(60, 1), end: CMTimeMakeWithSeconds(80, 1)),
            ranges: ranges
        )
    }

    fileprivate func testGetCMTimeRangeForPercentualPositionInVideo(position: Double, expectedTimeRange: CMTimeRange?, ranges: Array<Range<Double>>) {
        XCTAssertEqual(
            expectedTimeRange,
            getCMTimeRangeForPercentualPositionInVideo(
                videoDuration: CMTimeMakeWithSeconds(100, 1), selectedPosition: position, ranges: ranges
            )
        )
    }
}
