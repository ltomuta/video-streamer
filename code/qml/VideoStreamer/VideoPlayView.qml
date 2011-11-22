import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    orientationLock: PageOrientation.LockLandscape

    property bool isFullScreen: true

    function playVideo(videoUrl) {
        videoPlayer.stop()
        __enterFullScreen()
        __showVideoControls(false)
        videoPlayer.source = videoUrl
        videoPlayer.play()
    }

    function __enterFullScreen() {
        root.showToolBar = false
        root.showStatusBar = false
    }

    function __exitFullScreen() {
        root.showToolBar = true
        root.showStatusBar = true
    }

    function __showVideoControls(showControls) {
        videoPlayerControls.visible = showControls
    }

    function __toggleVideoControls() {
        videoPlayerControls.visible = !videoPlayerControls.visible
    }

    function __volumeUp() {
        var maxVol = 1.0
        var volThreshold = 0.1
        if (videoPlayer.volume < maxVol - volThreshold) {
            videoPlayer.volume += volThreshold
        } else {
            videoPlayer.volume = maxVol
        }
    }

    function __volumeDown() {
        var minVol = 0.0
        var volThreshold = 0.1
        if (videoPlayer.volume > minVol + volThreshold) {
            videoPlayer.volume -= volThreshold
        } else {
            videoPlayer.volume = minVol
        }
    }

    anchors.fill: parent

    Connections {
        target: volumeKeys
        onVolumeKeyUp: __volumeUp()
        onVolumeKeyDown: __volumeDown()
    }

    Connections {
        target: videoPlayerControls
        onBackButtonPressed: {
            videoPlayer.stop()
            __exitFullScreen()
            root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
        onPausePressed: {
            videoPlayer.pause()
        }
        onPlayPressed: {
            videoPlayer.play()
        }
    }

    Rectangle {
        id: bufferingIndicator

        anchors.fill: parent
        color: "black"
        z: videoPlayer.z + 1
        opacity: 1

        BusyIndicator {
            anchors.centerIn: parent
            height: visual.busyIndicatorHeight
            width: visual.busyIndicatorWidth
            running: true
        }
    }

    Rectangle {
        id: videoBackground
        anchors.fill: parent
        color: "black"
    }

    Video {
        id: videoPlayer

        onPositionChanged: {
            videoPlayerControls.timePlayed = position
            videoPlayerControls.timeRemaining = duration - position
        }

        volume: 0.1
        autoLoad: true
        anchors.fill: parent
        fillMode: Video.PreserveAspectFit
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                __toggleVideoControls()
            }
        }

        onPlayingChanged: videoPlayerControls.isPlaying = playing
        onPausedChanged: videoPlayerControls.isPlaying = !paused
    }

    VideoPlayerControls {
        id: videoPlayerControls
        anchors.bottom: parent.bottom
    }

    states: State {
        name: "BufferingDone"
        when: (videoPlayer.status === Video.Buffered ||
               videoPlayer.status === Video.EndOfMedia)

        PropertyChanges {
            target: bufferingIndicator
            opacity: 0
        }
    }
}

