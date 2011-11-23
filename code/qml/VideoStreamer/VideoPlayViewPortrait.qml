import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayViewPortrait

    // TODO: duplicated
    function playVideo(videoUrl) {
        videoPlayer.stop()
        videoPlayer.source = videoUrl
        videoPlayer.play()
    }

    VideoInformationView {
        id: videoInformationView

        anchors.left: parent.left
        anchors.top: parent.top
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: videoInformationView.bottom
            bottom: videoPlayerControls.top
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

            onPlayingChanged: videoPlayerControls.isPlaying = playing
            onPausedChanged: videoPlayerControls.isPlaying = !paused
        }
    }
    VideoPlayerControls {
        id: videoPlayerControls
        anchors.bottom: descriptionText.top
    }

    Text {
        id: descriptionText

        text: "blaa blaa blaa"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    // Default ToolBarLayout
    tools: ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
    }
}
