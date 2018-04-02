import Foundation
import CoreGraphics
import CoreMedia

func getRanges() -> Array<Range<Double>> {
    return getRangesFromInput(input: ranges)
}

func calculateScrubberKnobXPosition(duration: Double, currentSeconds: Double, scrubberWidth: Double) -> Double {
    if (duration == 0 || currentSeconds == 0) {
        return 0
    }
    return scrubberWidth * (currentSeconds / duration)
}

func getActiveScrubberZonesRects(scrubberRect: CGRect, videoRanges: Array<Range<Double>>) -> Array<CGRect> {
    if videoRanges.isEmpty {
        return [scrubberRect]
    }
    let scrubberWidth = scrubberRect.width
    return videoRanges.map { range in
        let widthPercent = CGFloat(range.upperBound - range.lowerBound)
        return CGRect(x: scrubberWidth * CGFloat(range.lowerBound), y: scrubberRect.origin.y, width: scrubberWidth * widthPercent, height: scrubberRect.height)
    }
}

func getCMTimeRangeForPercentualPositionInVideo(videoDuration: CMTime, selectedPosition: Double, ranges: Array<Range<Double>>) -> CMTimeRange {
    return findClosestRangeForPercentualPositionInVideo(selectedPosition: selectedPosition, ranges: ranges).map {
        CMTimeRange(
            start: CMTimeMakeWithSeconds(videoDuration.seconds * $0.lowerBound, videoDuration.timescale),
            end: CMTimeMakeWithSeconds(videoDuration.seconds * $0.upperBound, videoDuration.timescale))
    } ?? kCMTimeRangeInvalid
}

fileprivate func findClosestRangeForPercentualPositionInVideo(selectedPosition: Double, ranges: Array<Range<Double>>) -> Range<Double>? {
    if ranges.isEmpty {
        return nil
    }
    var closestRange: Range<Double>? = nil
    var closestDistance: Double? = nil
    ranges.forEach { range in
        var distance: Double = 0
        if selectedPosition < range.lowerBound {
            distance = range.lowerBound - selectedPosition
        } else if selectedPosition > range.upperBound {
            distance = selectedPosition - range.upperBound
        } else {
            distance = 0
        }
        
        if closestDistance == nil || distance < (closestDistance ?? 0) {
            closestDistance = distance
            closestRange = range
        }
    }
    
    return closestRange
}
