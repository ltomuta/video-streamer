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
        videoPlayer.source = videoUrl
        videoPlayer.play()
    }

    function __enterFullScreen() {
        console.log("__enterFullScreen")
        root.showToolBar = false
        root.showStatusBar = false
        videoPlayerControls.visible = false
    }

    function __exitFullScreen() {
        console.log("__exitFullScreen")

        //root.showToolBar = true
        //root.showStatusBar = true
        videoPlayerControls.visible = true
    }

    function __toggleFullScreen() {
        if (!isFullScreen) {
            __enterFullScreen()
            videoPlayView.isFullScreen = true;
        } else {
            __exitFullScreen()
            videoPlayView.isFullScreen = false;
        }
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
            root.showToolBar = true
            root.showStatusBar = true
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
        id: waitView

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        color: "black"
        z: videoPlayer.z + 1

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: qsTr("Buffering...")
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
                __toggleFullScreen()
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
        when: (videoPlayer.status !== Video.Buffering)

        PropertyChanges {
            target: waitView;
            opacity: 0
        }
    }
}

