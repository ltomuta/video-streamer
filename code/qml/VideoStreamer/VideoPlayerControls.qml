import QtQuick 1.1
import com.nokia.symbian 1.1
import "util.js" as Util

Item {
    id: videoPlayerControls

    property bool isPlaying: true
    property int timePlayed: 0
    property int timeRemaining: 0
    property bool showBackground: true
    property bool showBackButton: true

    signal backButtonPressed
    signal playPressed
    signal pausePressed

    width: screen.width
    height: visual.controlAreaHeight

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: videoPlayerControls.showBackground ? Qt.rgba(0.75, 0.75, 0.75, 0.75) : Qt.rgba(0,0,0,0)

        Loader {
            id: backButtonLoader

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: videoPlayerControls.showBackButton ? visual.controlMargins : 0
            sourceComponent: videoPlayerControls.showBackButton ? backButtonComponent : emptyPlaceholder
        }

        Component {
            id: backButtonComponent

            Button {
                text: "<-"
                width: visual.controlWidth
                height: visual.controlHeight
                onClicked: videoPlayerControls.backButtonPressed()
            }
        }

        Component {
            id: emptyPlaceholder

            Rectangle {
                width: 0
                height: 0
            }
        }

        Button {
            id: playButton

            text: videoPlayerControls.isPlaying ? "||" : ">"
            width: visual.controlWidth
            height: visual.controlHeight
            anchors.verticalCenter: backButtonLoader.verticalCenter
            anchors.left: backButtonLoader.right
            anchors.leftMargin: visual.controlMargins
            onClicked: {
                if (videoPlayerControls.isPlaying) {
                    videoPlayerControls.pausePressed()
                } else {
                    videoPlayerControls.playPressed()
                }
            }
        }

        Label {
            id: timeElapsedLabel

            text: Util.milliSecondsToString(timePlayed)
            anchors.bottom: playButton.verticalCenter
            anchors.left: playButton.right
            anchors.right: parent.right
            anchors.leftMargin: visual.controlMargins
            anchors.rightMargin: visual.controlMargins
        }

        Label {
            id: timeRemainingLabel

            text: Util.milliSecondsToString(timeRemaining)
            anchors.bottom: playButton.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: visual.controlMargins
        }

        ProgressBar {
            id: progressBar

            anchors.top: playButton.verticalCenter
            anchors.left: playButton.right
            anchors.right: timeRemainingLabel.right
            anchors.leftMargin: visual.controlMargins

            value: videoPlayerControls.timePlayed / (videoPlayerControls.timePlayed + videoPlayerControls.timeRemaining)
        }
    }
}
