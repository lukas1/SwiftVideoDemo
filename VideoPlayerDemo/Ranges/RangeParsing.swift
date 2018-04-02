import Foundation

let ranges = "(0.2, 0.4);(0.6, 0.8)"

func parseRange(input: String) -> Array<Range<Double>> {
    return input
        .replacingOccurrences(of: " ", with: "")
        .split(separator: ";")
        .flatMap {
            let values = $0
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: ",")
            if let first = values.first,
                let lowerBound = Double(first),
                let last = values.last,
                let upperBound = Double(last),
                lowerBound < upperBound,
                lowerBound < 1,
                upperBound < 1 {
                return lowerBound..<upperBound
            } else {
                return nil
            }
        }
}

func sortVideoRanges(input: Array<Range<Double>>) -> Array<Range<Double>> {
    return input.sorted { left, right in
        left.lowerBound < right.lowerBound
    }
}

func uniteOverlappingRanges(sortedRanges: Array<Range<Double>>) -> Array<Range<Double>> {
    return sortedRanges.reduce([]) { output, current in
        var mutableOutput = output
        if let prevRange = output.last, prevRange.upperBound >= current.lowerBound {
            mutableOutput.removeLast()
            mutableOutput.append(prevRange.lowerBound..<current.upperBound)
        } else {
            mutableOutput.append(current)
        }
        return mutableOutput
    }
}

func getRangesFromInput(input: String) -> Array<Range<Double>> {
    return uniteOverlappingRanges(sortedRanges: sortVideoRanges(input: parseRange(input: input)))
}
