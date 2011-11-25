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
        videoPlayer.source = videoUrl
        videoPlayer.play()
    }

    VideoInformationView {
        id: videoInformationView

        height: screen.height / 5
        anchors.left: parent.left
        anchors.top: parent.top
    }

    VideoPlayerView {
        id: videoPlayer
        anchors {
            left: parent.left
            right: parent.right
            top: videoInformationView.bottom
            bottom: videoPlayerControls.top
        }
    }

    VideoPlayerControls {
        id: videoPlayerControls

        timePlayed: videoPlayer.timePlayed
        timeRemaining: videoPlayer.timeRemaining
        isPlaying: videoPlayer.isPlaying

        showBackground: false
        showBackButton: false

        anchors.bottom: descriptionText.top

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

        //anchors.left: parent.left
        //anchors.right: parent.right
        anchors.bottom: parent.bottom

        width: parent.width
        height: screen.height / 4
        contentWidth: descriptionText.width
        contentHeight: descriptionText.height + 300
        clip: true

        Label {

            anchors.fill: parent
            text: videoPlayViewPortrait.videoDescription

            elide: "ElideNone"
            wrapMode: Text.WordWrap
            //maximumLineCount: 40
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
