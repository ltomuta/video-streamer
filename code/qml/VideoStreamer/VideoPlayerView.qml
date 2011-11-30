import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Item {
    id: videoPlayerContainer

    property alias source: videoPlayerImpl.source
    property alias duration: videoPlayerImpl.duration
    property alias timePlayed: videoPlayerImpl.position
    property int timeRemaining: videoPlayerImpl.duration - timePlayed
    property bool isPlaying: false

    signal toggled

    function play() {
        videoPlayerImpl.play()
    }

    function stop() {
        videoPlayerImpl.stop()
    }

    function pause() {
        videoPlayerImpl.pause()
    }

    function __volumeUp() {
        var maxVol = 1.0
        var volThreshold = 0.1
        if (videoPlayerImpl.volume < maxVol - volThreshold) {
            videoPlayerImpl.volume += volThreshold
        } else {
            videoPlayerImpl.volume = maxVol
        }
    }

    function __volumeDown() {
        var minVol = 0.0
        var volThreshold = 0.1
        if (videoPlayerImpl.volume > minVol + volThreshold) {
            videoPlayerImpl.volume -= volThreshold
        } else {
            videoPlayerImpl.volume = minVol
        }
    }

    Rectangle {
        id: background

        z: videoPlayerImpl.z - 1
        color: "black"
        anchors.fill: parent
        visible: true
    }


    Video {
        id: videoPlayerImpl

        volume: 0.1
        autoLoad: true
        anchors.fill: parent
        fillMode: Video.PreserveAspectFit
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                videoPlayerContainer.toggled()
            }
        }

        onPlayingChanged: videoPlayerContainer.isPlaying = playing
        onPausedChanged: videoPlayerContainer.isPlaying = !paused

        onStatusChanged: {
            if (status === Video.Buffered) {
                bufferingIndicator.visible = false
                videoBackground.visible = false
            } else if (status === Video.EndOfMedia) {
                bufferingIndicator.visible = false
                videoBackground.visible = false
                stop()
                position = 0
            } else {
                if (!videoPlayerContainer.isPlaying) {
                    bufferingIndicator.visible = true

                    // Video element will show random data
                    // when starting video playback.
                    if (position === 0) {
                        videoBackground.visible = true
                    } else {
                        videoBackground.visible = false
                    }
                }
            }
        }
    }

    Rectangle {
        id: videoBackground

        z: videoPlayerImpl.z + 1
        color: "black"
        anchors.fill: parent
        visible: false
    }

    BusyIndicator {
        id: bufferingIndicator

        z: videoBackground.z + 1
        anchors.centerIn: parent
        height: visual.busyIndicatorHeight
        width: visual.busyIndicatorWidth
        running: true
    }

    Connections {
        target: volumeKeys
        onVolumeKeyUp: __volumeUp()
        onVolumeKeyDown: __volumeDown()
    }
}
