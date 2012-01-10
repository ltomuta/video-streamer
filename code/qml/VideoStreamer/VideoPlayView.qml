import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    property bool isFullScreen: true
    property bool isPortrait: visual.inPortrait

    property string videoTitle: ""
    property int videoLength: 0
    property string videoAuthor: ""
    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0
    property string videoDescription: ""

    property double topAreaProportion: visual.topAreaProportion
    property double bottomAreaProportion: visual.bottomAreaProportion
    property double leftAreaProportion: visual.leftAreaProportion
    property double rightAreaProportion: visual.rightAreaProportion


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
        __showVideoControls(true)
        videoPlayer.source = model.m_contentUrl
        videoPlayer.play()
    }

    function __enterFullScreen() {
        // TODO! Perhaps some fullscreenMode -property should be used?
        // (i.e. Might be needed for real full screen video playback)
        if (!isPortrait) {
            showToolBar = false
//            showStatusBar = false
        }
    }

    function __exitFullScreen() {
        if (!isPortrait) {
            showToolBar = true
            showStatusBar = true
        }
    }

    function __showVideoControls(showControls) {
        overlayLoader.state = showControls ? "" : "Hidden"
    }

    function __toggleVideoControls() {
        if (!isPortrait) {
            if (overlayLoader.state == "") {
                overlayLoader.state = "Hidden";
            } else {
                overlayLoader.state = "";
            }
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
//            showStatusBar = false
        } else {
            showToolBar = true
            showStatusBar = true
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            // Don't show the bg image behind the video play view.
            visual.showBackground = false;
        } else if (status === PageStatus.Deactivating) {
            // The background image can be shown once again.
            visual.showBackground = true;
        }
    }

    anchors.fill: parent


    // The Video can be played either in portrait or landscape mode. The
    // VideoInformationView is selected to be on the top when in portrait,
    // and when in landscape, only the video title is being shown.
    Component {
        id: videoInformation

        VideoInformationView {
            width: videoPlayView.width
            videoTitle: videoPlayView.videoTitle
            numLikes: videoPlayView.numLikes
            numDislikes: videoPlayView.numDislikes
            viewCount: videoPlayView.viewCount
        }
    }

    Component {
        id: landscapeTitle

        InfoTextLabel {
            maximumLineCount: 1
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            text: videoPlayView.videoTitle
            font.bold: true
        }
    }

    // Loader, which selects what to show on the upper part of the screen.
    Loader {
        id: upperAreaLoader
        height: videoPlayView.height * topAreaProportion
        anchors {
            top: parent.top
            topMargin: visual.margins
            left: parent.left
            leftMargin: isPortrait ? 0 : visual.margins
            right: parent.right
        }

        sourceComponent: isPortrait ? videoInformation : landscapeTitle
    }


    // In landscape there's an extra loader for the right side of the screen,
    // which will load basically the same information (views, likes & dislikes)
    // as in the upperAreaLoader in portrait mode.
    Component {
        id: videoInformationLS

        VideoInformationViewLS {
            numLikes: videoPlayView.numLikes
            numDislikes: videoPlayView.numDislikes
            viewCount: videoPlayView.viewCount
        }
    }

    Loader {
        id: rightAreaLoader
        anchors {
            top: upperAreaLoader.bottom
            topMargin: visual.margins
            right: parent.right
            bottom: bottomAreaLoader.top
        }

        sourceComponent: isPortrait ? undefined : videoInformationLS
    }


    // The video playback area itself. Size for it is being determined by the
    // orientation and calculated proportionally based on the parent dimensions.
    VideoPlayerView {
        id: videoPlayer

        anchors {
            top: upperAreaLoader.bottom
            bottom: isPortrait ? bottomAreaLoader.top : overlayLoader.top
            left: parent.left
            right: parent.right
            leftMargin: isPortrait ? 0 : videoPlayView.width * visual.leftAreaProportion
            rightMargin: isPortrait ? 0 : videoPlayView.width * visual.rightAreaProportion
        }

        // TODO: Disabled for now, because there's no need to toggle the video
        // controls in detailed views. Needed only in full screen playback mode.
//        onToggled: __toggleVideoControls()
    }


    // Overlay controls on top of the video. Also always shown, when in
    // landscape and not in full screen video playback mode.
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

    // Loader for the overlay components.
    Loader {
        id: overlayLoader

        state: "Hidden"
        sourceComponent: !isPortrait ? overlayComponent : undefined
        // Don't use anchoring here, use y-coordinate instead, so that
        // it can be animated.
        y: parent.height-visual.controlAreaHeight
        // anchors.bottom: parent.bottom
        width: videoPlayView.width
        height: visual.controlAreaHeight

        states: [
            // Inactive state.
            State {
                name: "Hidden"
                PropertyChanges {
                    target: overlayLoader
                    // Move the controls 'beneath' the screen
                    // and make it completely transparent.
                    y: videoPlayView.height
                    opacity: 0.0
                }
            }
        ]

        transitions: [
            // Transition between active and inactive states.
            Transition {
                from: "";  to: "Hidden"; reversible: true
                ParallelAnimation {
                    PropertyAnimation {
                        properties: "opacity"
                        easing.type: Easing.InOutExpo
                        duration: visual.animationDurationShort
                    }
                    PropertyAnimation {
                        properties: "y"
                        duration: visual.animationDurationNormal
                    }
                }
            }
        ]
    }


    // Finally, the bottom area stuff, i.e. the player controls in
    // portrait mode (as the 'overlay controls' are being shown in landscape).
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

    Loader {
        id: bottomAreaLoader
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        sourceComponent: isPortrait ? bottomArea : undefined
    }

    // Tools (= back button). Shown in portrait mode, hidden whan in
    // landscape(/fullscreen).
    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: __handleExit()
        }
    }
}
