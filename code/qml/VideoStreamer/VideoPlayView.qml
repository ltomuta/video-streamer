import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    property bool isFullScreen: true
    property bool isPortrait: screen.width < screen.height

    property string videoTitle: ""
    property int videoLength: 0
    property string videoAuthor: ""
    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0
    property string videoDescription: ""

    property double topAreaProportion: visual.topAreaProportion
    property double bottomAreaProportion: visual.bottomAreaProportion

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
        if (!isPortrait) {
            root.showToolBar = false
            root.showStatusBar = false
        }
    }

    function __exitFullScreen() {
        if (!isPortrait) {
            root.showToolBar = true
            root.showStatusBar = true
        }
    }

    function __showVideoControls(showControls) {
        overlayLoader.visible = showControls
    }

    function __toggleVideoControls() {
        if (!isPortrait) {
            overlayLoader.visible = !overlayLoader.visible
        }
    }

    function __handleExit() {
        videoPlayer.stop()
        __exitFullScreen()
        root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
    }

    onIsPortraitChanged: {
        if (!isPortrait) {
            root.showToolBar = false
            root.showStatusBar = false
        } else {
            root.showToolBar = true
            root.showStatusBar = true
        }
    }

    anchors.fill: parent

    Component {
        id: videoInformation

        VideoInformationView {
            width: videoPlayView.width
            height: videoPlayView.height * topAreaProportion
            numLikes: videoPlayView.numLikes
            numDislikes: videoPlayView.numDislikes
            viewCount: videoPlayView.viewCount
        }
    }

    Component {
        id: emptyStub

        Item {}
    }

    Loader {
        id: upperAreaLoader
        anchors {
            top: parent.top
            topMargin: visual.margins
            left: parent.left
            right: parent.right
        }

        sourceComponent: isPortrait ? videoInformation : emptyStub
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
        sourceComponent: !isPortrait ? overlayComponent : emptyStub
        anchors.bottom: parent.bottom
        width: videoPlayView.width
        height: visual.controlAreaHeight
    }

    Component {
        id: overlayComponent
        VideoPlayerControls {
            id: videoPlayerControls

            timePlayed: videoPlayer.timePlayed
            timeRemaining: videoPlayer.duration
            isPlaying: videoPlayer.isPlaying


            onBackButtonPressed: {
                __handleExit()
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
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        sourceComponent: isPortrait ? bottomArea : emptyStub
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
                timeRemaining: videoPlayer.duration
                isPlaying: videoPlayer.isPlaying

                showBackground: false
                showBackButton: false

                onPausePressed: {
                    videoPlayer.pause()
                }

                onPlayPressed: {
                    videoPlayer.play()
                }
            }

            InfoTextLabel {
                id: titleLabel

                anchors.top: videoPlayerControls.bottom
                anchors.left: parent.left
                anchors.margins: visual.margins
                width: screen.width
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                text: videoPlayView.videoTitle
                font.bold: true
            }

            Flickable {
                id: descriptionText

                anchors {
                    top: titleLabel.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                contentWidth: descriptionText.width
                contentHeight: videoDescriptionText.paintedHeight
                clip: true

                InfoTextLabel {
                    id: videoDescriptionText
                    anchors.fill: parent
                    text: videoPlayView.videoDescription

                    elide: "ElideNone"
                    wrapMode: Text.WordWrap
                    anchors.margins: visual.margins
                }

                ScrollDecorator {
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    // flickableItem binds the scroll decorator to the ListView.
                    flickableItem: descriptionText
                }
            }
        }
    }

    tools: ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: __handleExit()
        }
    }
}
