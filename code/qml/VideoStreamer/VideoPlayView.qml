import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    property bool isFullScreen: true

    function playVideo(model) {
        videoPlayer.stop()
        __enterFullScreen()
        __showVideoControls(false)
        videoPlayer.source = model.m_contentUrl
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

    orientationLock: PageOrientation.LockLandscape
    anchors.fill: parent

    VideoPlayerView {
        id: videoPlayer

        anchors.fill: parent

        onToggled: __toggleVideoControls()
    }

    VideoPlayerControls {
        id: videoPlayerControls

        anchors.bottom: parent.bottom
        width: screen.width
        height: visual.controlAreaHeight

        timePlayed: videoPlayer.timePlayed
        timeRemaining: videoPlayer.timeRemaining
        isPlaying: videoPlayer.isPlaying


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
}

