import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var scrubber: ScrubberView!
    @IBOutlet weak var playControl: UIButton!

    fileprivate let asset: AVURLAsset? = {
        guard let path = Bundle.main.path(forResource: "videoplayback", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return nil
        }
        return AVURLAsset(url: URL(fileURLWithPath: path))
    }()

    fileprivate lazy var playerItem: AVPlayerItem? = { return asset.map(AVPlayerItem.init) }()

    fileprivate var player: AVQueuePlayer = AVQueuePlayer()

    fileprivate lazy var videoLayer: AVPlayerLayer = AVPlayerLayer(player: player).apply {
        $0.videoGravity = AVLayerVideoGravity.resize
    }

    fileprivate lazy var videoRanges: Array<Range<Double>> = getRanges()

    fileprivate var videoDurationInSeconds: Double { return asset?.duration.seconds ?? 0 }

    fileprivate var looper: AVPlayerLooper? = nil

    @IBAction func onPlayControlTouched(_ sender: Any) {
        togglePlayback(isPlayingNow: player.timeControlStatus == .playing)
    }

    fileprivate func togglePlayback(isPlayingNow: Bool) {
        if isPlayingNow {
            player.pause()
        } else {
            if looper == nil {
                attemptSettingUpLooperForPosition(positionPercent: 0)
            }
            player.play()
        }

        playControl.setTitle(!isPlayingNow ? "Pause" : "Play", for: UIControlState.normal) // TODO: Localization, not doing for this demo
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoLayer.frame = videoView.layer.bounds
        scrubber.setActiveZones(activeZones: getActiveScrubberZonesRects(scrubberRect: scrubber.bounds, videoRanges: videoRanges))
    }
    
    fileprivate func setupView() {
        videoView.layer.addSublayer(videoLayer)
        scrubber.scrubberTappedEvent = { [weak self] positionPercent in
            self?.attemptSettingUpLooperForPosition(positionPercent: positionPercent)
        }
    }

    fileprivate func setupPlayer() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main, using: handleTime)
        playerItem.map(player.replaceCurrentItem)
    }
    
    fileprivate func handleTime(time: CMTime) {
        scrubber.setScrubberKnobPosition(
            position: calculateScrubberKnobXPosition(
                duration: videoDurationInSeconds,
                currentSeconds: time.seconds,
                scrubberWidth: Double(scrubber.frame.width)
            )
        )
    }

    fileprivate func getPlayerLooperForPositionPercent(positionPercent: Double, player: AVQueuePlayer, playerItem: AVPlayerItem, duration: CMTime) -> AVPlayerLooper {
        let range = getCMTimeRangeForPercentualPositionInVideo(
            videoDuration: duration,
            selectedPosition: positionPercent,
            ranges: videoRanges
        )
        return AVPlayerLooper(
            player: player,
            templateItem: playerItem,
            timeRange: range
        )
    }

    fileprivate func attemptSettingUpLooperForPosition(positionPercent: Double) {
        looper?.disableLooping()

        guard let playerItem = playerItem else {
            debugPrint("Failed to find get playerItem")
            return
        }

        looper = getPlayerLooperForPositionPercent(
            positionPercent: positionPercent,
            player: player,
            playerItem: playerItem,
            duration: asset?.duration ?? kCMTimeZero
        )
        togglePlayback(isPlayingNow: false)
    }
}

