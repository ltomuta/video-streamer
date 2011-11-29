import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    tools: ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
    }

    property bool isFullScreen: true
    property bool isPortrait: screen.width < screen.height

    property string videoTitle: ""
    property int videoLength: 0
    property string videoAuthor: ""
    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0
    property string videoDescription: ""

    property double topAreaProportion: 0.2
    property double bottomAreaProportion: 0.3


    function playVideo(model) {

        videoPlayView.videoTitle = model.m_title
        videoPlayView.videoLength = model.m_duration
        videoPlayView.videoAuthor = model.m_author

        videoPlayView.numLikes = model.m_numLikes
        videoPlayView.numDislikes = model.m_numDislikes
        videoPlayView.viewCount = model.m_viewCount

        videoPlayView.videoDescription = model.m_description


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
        overlayLoader.visible = showControls
    }

    function __toggleVideoControls() {
        if (!isPortrait) {
            overlayLoader.visible = !overlayLoader.visible
        }
    }

    anchors.fill: parent


    Component {
        id: videoInformation


        VideoInformationView {
            width: videoPlayView.width
            height: videoPlayView.height * topAreaProportion

            videoTitle: videoPlayView.videoTitle
            videoLength: videoPlayView.videoLength
            videoAuthor: videoPlayView.videoLength
            numLikes: videoPlayView.numLikes
            numDislikes: videoPlayView.numDislikes
            viewCount: videoPlayView.viewCount

        }

    }

    Component {
        id: videoInformationStub

        Item {}
    }

    Loader {
        id: upperAreaLoader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        sourceComponent: isPortrait ? videoInformation : videoInformationStub
    }

    // Video player area
    VideoPlayerView {
        id: videoPlayer

        anchors {
            top: upperAreaLoader.bottom
            bottom: bottomAreaLoader.top
            left: parent.left
            right: parent.right
        }


        onToggled: __toggleVideoControls()
    }

    Loader {
        id: overlayLoader

        visible: false
        sourceComponent: !isPortrait ? overlayComponent : videoInformationStub
        anchors.bottom: parent.bottom
        width: videoPlayView.width
        height: visual.controlAreaHeight
    }

    Component {
        id: overlayComponent
        VideoPlayerControls {
            id: videoPlayerControls

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

    Loader {
        id: bottomAreaLoader
        //anchors.top: videoPlayer.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        sourceComponent: isPortrait ? bottomArea : videoInformationStub
    }


    Component {
        id: bottomArea

        Item {
            height: videoPlayView.height * bottomAreaProportion

            VideoPlayerControls {
                id: videoPlayerControls

                anchors.top: parent.top
                width: videoPlayView.width
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

                anchors {
                    top: videoPlayerControls.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                contentWidth: descriptionText.width
                contentHeight: descriptionText.height
                clip: true

                InfoTextLabel {

                    anchors.fill: parent
                    text: videoPlayView.videoDescription

                    elide: "ElideNone"
                    wrapMode: Text.WordWrap
                    anchors.margins: visual.margins
                }
            }
        }
    }

}

