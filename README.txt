Single screen demo, playing a video bundled with the app.

If you want to see it in action, add to the root of this project file videoplayback.mp4

Code in RangeParsing.swift and PlayerLogic.swift is not encapsulated in a class.
This is a conscious decision, as all functions in these files are stateless, not relying
on external state (except getRanges() for obvious reasons), without side-effects.
Therefore there are no added benefits of wrapping them in a class. This is closer to
functional style programming.

Methods in the above mentioned files are tested via Unit tests.

For seamless looping AVPlayerLooper is used as suggested by: 
https://developer.apple.com/videos/play/wwdc2016/503/

