import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: videoPlayView
    property bool isFullScreen: false
    property bool isPortrait: visual.inPortrait

    property string videoTitle: ""
    property int videoLength: 0
    property string videoAuthor: ""
    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0
    property string videoDescription: ""
    property string videoSource: ""

    property double topAreaProportion: visual.topAreaProportion
    property double bottomAreaProportion: visual.bottomAreaProportion
    property double leftAreaProportion: visual.leftAreaProportion
    property double rightAreaProportion: visual.rightAreaProportion

    signal videoExit

    // Ease of access handle for the VideoPlayerView Item.
    property alias videoPlayer: videoPlayerLoader.item

    function setVideoData(videoData) {
        videoPlayView.videoTitle = videoData.m_title;
        videoPlayView.videoLength = videoData.m_duration;
        videoPlayView.videoAuthor = videoData.m_author;

        videoPlayView.numLikes = videoData.m_numLikes;
        videoPlayView.numDislikes = videoData.m_numDislikes;
        videoPlayView.viewCount = videoData.m_viewCount;

        videoPlayView.videoDescription = videoData.m_description;

        videoPlayView.videoSource = videoData.m_contentUrl;
    }

    function __showVideoControls(showControls) {
        overlayLoader.state = showControls ? "" : "Hidden"
    }

    function __toggleVideoControls() {
        // Disable automatic control hiding
        controlHideTimer.shouldRun = false
        controlHideTimer.stop()

        if (overlayLoader.state == "") {
            overlayLoader.state = "Hidden";
        } else {
            overlayLoader.state = "";
        }
    }

    function __handleExit() {
        videoPlayer.stop()

        videoPlayView.videoExit();
    }

    function __playbackStarted() {
        controlHideTimer.startHideTimer()
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
                    videoPlayer.playbackStarted.connect(__playbackStarted)
                }
                videoPlayer.stop();
                __showVideoControls(true);
                videoPlayer.source = videoPlayView.videoSource;
                videoPlayer.play();
            } else {
                console.log("Player loader NOT READY! Status: "
                            + videoPlayerLoader.status);
            }
        }
    }

    // Timer responsible for hiding controls after entering
    // full screen player.
    Timer {
        id: controlHideTimer

        property bool shouldRun: videoPlayView.isFullScreen ? true : false

        function startHideTimer() {
            if (controlHideTimer.shouldRun) {
                start()
            }
        }

        running: false
        interval: visual.videoControlsHideTimeout

        onTriggered: {
            controlHideTimer.shouldRun = false;
            if (videoPlayer.isPlaying) {
                __showVideoControls(false);
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
            bottom: videoPlayView.isFullScreen ? overlayLoader.top : videoPlayerLoader.bottom
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
