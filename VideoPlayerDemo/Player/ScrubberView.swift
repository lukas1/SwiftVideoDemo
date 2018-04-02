import Foundation
import UIKit

class ScrubberView: UIView {
    fileprivate let scrubberKnob: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).apply { $0.backgroundColor = UIColor.orange }
    fileprivate var activeZones: Array<UIView> = []

    var scrubberTappedEvent: (_ positionPercent: Double) -> Void = { _ in }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        addSubview(scrubberKnob)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onScrubberTapped)))
    }

    @objc func onScrubberTapped(recognizer: UITapGestureRecognizer) {
        scrubberTappedEvent(Double(recognizer.location(in: self).x) / Double(frame.width))
    }
    
    func setScrubberKnobPosition(position: Double) {
        var frame = scrubberKnob.frame
        frame.origin.x = CGFloat(position)
        scrubberKnob.frame = frame
    }

    func setActiveZones(activeZones: Array<CGRect>) {
        self.activeZones.forEach { $0.removeFromSuperview() }
        self.activeZones = activeZones.map {
            UIView(frame: $0).apply {
                $0.backgroundColor = UIColor.green
            }
        }
        self.activeZones.forEach { insertSubview($0, belowSubview: scrubberKnob) }
    }
}
