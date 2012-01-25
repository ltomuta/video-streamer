import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayView
    property bool isFullScreen: false
    property bool isPortrait: visual.inPortrait

    property string videoTitle: model.m_title
    property int videoLength: model.m_duration
    property string videoAuthor: model.m_author
    property int numLikes: model.m_numLikes
    property int numDislikes: model.m_numDislikes
    property int viewCount: model.m_viewCount
    property string videoDescription: model.m_description

    property double topAreaProportion: visual.topAreaProportion
    property double bottomAreaProportion: visual.bottomAreaProportion
    property double leftAreaProportion: visual.leftAreaProportion
    property double rightAreaProportion: visual.rightAreaProportion

    // Ease of access handle for the VideoPlayerView Item.
    property alias videoPlayer: videoPlayerLoader.item

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

    // A timer, which will give a small amount of time for the (page changing)
    // transitions to complete before the video loading is started. This is
    // done this way because otherwise the immediate loading of the video would
    // cause lagging & un-smooth animations.
    Timer {
        id: timer

        running: true
        interval: visual.animationDurationPrettyLong

        onTriggered: {
            stop();
            // The video playback area itself. Size for it is being determined by the
            // orientation and calculated proportionally based on the parent dimensions.
            videoPlayerLoader.sourceComponent = Qt.createComponent("VideoPlayerView.qml");

            if (videoPlayerLoader.status === Loader.Ready) {
                if (videoPlayView.isFullScreen) {
                    videoPlayer.toggled.connect(__toggleVideoControls)
                }
                videoPlayer.stop();
                __showVideoControls(true);
                videoPlayer.source = model.m_contentUrl;
                videoPlayer.play();
            } else {
                console.log("Player loader NOT READY! Status: "
                            + videoPlayerLoader.status);
            }
        }
    }

    Component {
        id: videoTitleComp

        VideoInfoTextLabel {
            maximumLineCount: isPortrait ? 2 : 1
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            text: videoPlayView.videoTitle
            font.bold: true
        }
    }

    // Loader, which selects what to show on the upper part of the screen.
    Loader {
        id: upperAreaLoader
        height: videoPlayView.isFullScreen ? 0 : (videoPlayView.height * topAreaProportion)
        anchors {
            top: parent.top
            topMargin: videoPlayView.isFullScreen ? 0 : visual.margins
            left: parent.left
            leftMargin: videoPlayView.isFullScreen ? 0 : (isPortrait ? 0 : visual.margins)
            right: parent.right
        }

        sourceComponent: videoPlayView.isFullScreen ? undefined : videoTitleComp
    }

    // The Video can be played either in portrait or landscape mode. The
    // VideoInformationView is selected to be on the bottom when in portrait,
    // and when in landscape, the information is shown on the right side.
    Component {
        id: videoInformation

        VideoInformationView {
            videoTitle: videoPlayView.videoTitle
            numLikes: videoPlayView.numLikes
            numDislikes: videoPlayView.numDislikes
            viewCount: videoPlayView.viewCount
        }
    }

    // Loader, which selects what to show on the bottom part of the screen.
    Loader {
        id: bottomAreaLoader
        height: videoPlayView.isFullScreen ? 0 : (videoPlayView.height * bottomAreaProportion)
        width: videoPlayView.isFullScreen ? 0 : (videoPlayView.width / 3)
        anchors {
            bottom: parent.bottom
            bottomMargin: videoPlayView.isFullScreen ? 0 : visual.margins
            horizontalCenter: parent.horizontalCenter
        }

        sourceComponent: videoPlayView.isFullScreen ? undefined : (isPortrait ? videoInformation : undefined)
    }

    // In landscape there's an extra loader for the right side of the screen,
    // which will load basically the same information (views, likes & dislikes)
    // as in the upperAreaLoader in portrait mode.
    Loader {
        id: rightAreaLoader

        width: videoPlayView.isFullScreen ? 0 : (videoPlayView.width / 5)
        height: videoPlayView.isFullScreen ? 0 : videoPlayerLoader.height
        anchors {
            right: parent.right
            rightMargin: videoPlayView.isFullScreen ? 0 : (visual.isE6 ? visual.margins * 9 : visual.margins * 6)
            verticalCenter: videoPlayView.verticalCenter
        }

        sourceComponent: videoPlayView.isFullScreen ? undefined : (isPortrait ? undefined : videoInformation)
    }

    // Loader for the VideoPlayerComponent. NOTE: The sourceComponent will be
    // set a bit later, after the timer has triggered.
    Loader {
        id: videoPlayerLoader

        height: videoPlayView.isFullScreen ? screen.height : (videoPlayView.height
                * (1 - visual.topAreaProportion - visual.bottomAreaProportion))
        anchors {
            top: upperAreaLoader.bottom
            left: parent.left
            right: parent.right
            leftMargin: videoPlayView.isFullScreen ? 0 : (videoPlayView.width * visual.leftAreaProportion)
            rightMargin: videoPlayView.isFullScreen ? 0 : videoPlayView.width * visual.rightAreaProportion
        }
    }

    // Slider type of indicator that shows the current volume level.
    VolumeIndicator {
        anchors {
            left: parent.left
            leftMargin: visual.margins
            top: videoPlayerLoader.top
            bottom: videoPlayerLoader.bottom
        }

        value: videoPlayer ? videoPlayer.volume : 0
    }

    // Overlay controls on top of the video. Also always shown, when in
    // landscape and not in full screen video playback mode.
    Component {
        id: overlayComponent
        VideoPlayerControls {
            id: videoPlayerControls

            timePlayed: videoPlayer ? videoPlayer.timePlayed : 0
            timeDuration: videoPlayer ? videoPlayer.duration : 0
            isPlaying: videoPlayer ? videoPlayer.isPlaying : false

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

    // Loader for the overlay components, i.e. the VideoPlayerControls.
    Loader {
        id: overlayLoader

        state: "Hidden"
        sourceComponent: overlayComponent
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

    // TODO!: Both of the view modes (portrait/landscape) currently use the
    // customized VideoControls, so don't show the toolbar.
    //
    // Tools (= back button). Shown in portrait mode, hidden whan in
    // landscape(/fullscreen).
//    tools: ToolBarLayout {
//        ToolButton {
//            flat: true
//            iconSource: "toolbar-back"
//            onClicked: __handleExit()
//        }
//    }
}
