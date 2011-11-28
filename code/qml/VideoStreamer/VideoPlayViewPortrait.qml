import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayViewPortrait

    property string videoDescription: ""

    // TODO: duplicated
    function playVideo(model) {
        videoDescription = model.m_description
        videoInformationView.videoTitle = model.m_title
        videoInformationView.videoLength = model.m_duration
        videoInformationView.videoAuthor = model.m_author

        videoInformationView.numLikes = model.m_numLikes
        videoInformationView.numDislikes = model.m_numDislikes
        videoInformationView.viewCount = model.m_viewCount


        videoPlayer.stop()
        videoPlayer.source = model.m_contentUrl
        videoPlayer.play()
    }

    anchors.fill: parent

    Item {
        id: topArea

        height: screen.height / 5
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top

        VideoInformationView {
            id: videoInformationView

            anchors.fill: parent
        }
    }

    Item {
        id: middleArea

        height: screen.height / 3

        anchors {
            left: parent.left
            right: parent.right
            top: topArea.bottom
        }

        VideoPlayerView {
            id: videoPlayer

            anchors.fill: parent
        }
    }

    Item {
        id: bottomArea

        anchors {
            left: parent.left
            right: parent.right
            top: middleArea.bottom
            bottom: parent.bottom
        }

        VideoPlayerControls {
            id: videoPlayerControls

            anchors.top: parent.top
            width: screen.width
            height: visual.controlAreaHeight


            timePlayed: videoPlayer.timePlayed
            timeRemaining: videoPlayer.timeRemaining
            isPlaying: videoPlayer.isPlaying

            showBackground: false
            showBackButton: false

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

        Flickable {
            id: descriptionText

            anchors.top: videoPlayerControls.bottom
            anchors.bottom: parent.bottom

            width: parent.width
            height: screen.height / 4
            contentWidth: descriptionText.width
            contentHeight: descriptionText.height + 300
            clip: true

            InfoTextLabel {

                anchors.fill: parent
                text: videoPlayViewPortrait.videoDescription

                elide: "ElideNone"
                wrapMode: Text.WordWrap
                anchors.margins: visual.margins
            }
        }
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
