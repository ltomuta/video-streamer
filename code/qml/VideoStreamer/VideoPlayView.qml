import QtQuick 1.0
import com.nokia.meego 1.0

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
            showToolBar = false
            showStatusBar = false
        }
    }

    function __exitFullScreen() {
        if (!isPortrait) {
            showToolBar = true
            showStatusBar = true
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

        // VideoPlayView was dynamically created in VideoListItem and must
        // be destroyed. However just calling destroy without any delay will
        // block whole application if Video-element status is Video.Loading.
        // To prevent this give Video-element enough time to handle it's
        // state and delay destroy by 1 minute.
        videoPlayView.destroy(60000)
        pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
    }

    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Right:
                console.log("TODO: Fast forward");
                event.accepted = true;
                break;
            case Qt.Key_Left:
                console.log("TODO: Reverse");
                event.accepted = true;
                break;
            case Qt.Key_Select:
            case Qt.Key_Enter:
            case Qt.Key_Return:
                if(videoPlayer.isPlaying) {
                    videoPlayer.pause();
                } else {
                    videoPlayer.play();
                }
                event.accepted = true;
                break;
            }
        }
    }

    onIsPortraitChanged: {
        if (!isPortrait) {
            showToolBar = false
            showStatusBar = false
        } else {
            showToolBar = true
            showStatusBar = true
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
            timeDuration: videoPlayer.duration
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
                timeDuration: videoPlayer.duration
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
