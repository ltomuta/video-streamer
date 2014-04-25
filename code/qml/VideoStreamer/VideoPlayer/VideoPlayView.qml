/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: videoPlayView

    // Enable/Disable rewinding/fast forwarding.
    property bool enableScrubbing: false
    // Set the video playback in either full or partial screen.
    property bool isFullScreen: false
    property bool isPortrait: visual.inPortrait

    // Video information data to be shown, when in partial screen mode.
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

    // Ease of access handle for the VideoPlayerView Item.
    property alias videoPlayer: videoPlayerLoader.item

    // Property to observe the application shown/hidden status
    property bool applicationActive: Qt.application.active

    // Signalled, when exiting the Video player.
    signal videoExit

    // Function for setting the shown video information & setting the
    // video URL.
    function setVideoData(videoData) {
        videoPlayView.videoTitle = videoData.m_title ? videoData.m_title : "";
        videoPlayView.videoLength = videoData.m_duration ? videoData.m_duration : 0;
        videoPlayView.videoAuthor = videoData.m_author ? videoData.m_author : "";

        videoPlayView.numLikes = videoData.m_numLikes ? videoData.m_numLikes : 0;
        videoPlayView.numDislikes = videoData.m_numDislikes ? videoData.m_numDislikes : 0;
        videoPlayView.viewCount = videoData.m_viewCount ? videoData.m_viewCount : 0;

        videoPlayView.videoDescription = videoData.m_description ? videoData.m_description : "";

        // At least the m_contentUrl HAS to be defined!
        videoPlayView.videoSource = videoData.m_contentUrl;
    }

    function __showVideoControls(showControls) {
        overlayLoader.state = showControls ? "" : "Hidden";
    }

    function __toggleVideoControls() {
        // Disable automatic control hiding
        controlHideTimer.shouldRun = false;
        controlHideTimer.stop();

        if (overlayLoader.state == "") {
            overlayLoader.state = "Hidden";
        } else {
            overlayLoader.state = "";
        }
    }

    function __handleExit() {
        videoPlayer.stop();
        videoPlayer.disconnect();
        videoPlayView.videoExit();
    }

    function __playbackStarted() {
        controlHideTimer.startHideTimer();
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

    // When going to background, pause the playback. And when returning from
    // background, resume playback.
    onApplicationActiveChanged: {
        if (videoPlayer) {
            if(applicationActive) {
                videoPlayer.play();
            } else {
                videoPlayer.pause();
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
            // The video playback area itself. Size for it is being determined
            // by the orientation and calculated proportionally based
            // on the parent dimensions.
            videoPlayerLoader.sourceComponent =
                    Qt.createComponent("VideoPlayerView.qml");

            if (videoPlayerLoader.status === Loader.Ready) {
                if (videoPlayView.isFullScreen) {
                    videoPlayer.toggled.connect(__toggleVideoControls);
                    videoPlayer.playbackStarted.connect(__playbackStarted);
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
                start();
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

        anchors {
            top: parent.top
            topMargin: videoPlayView.isFullScreen ? 0 : visual.margins
            left: parent.left
            leftMargin: videoPlayView.isFullScreen ? 0 : visual.margins
            right: parent.right
        }
        height: videoPlayView.isFullScreen ?
                    0 : (videoPlayView.height * topAreaProportion)

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

        height: videoPlayView.isFullScreen ?
                    0 : (videoPlayView.height * bottomAreaProportion)
        width: videoPlayView.isFullScreen ? 0 : (videoPlayView.width / 3)
        anchors {
            bottom: parent.bottom
            bottomMargin: videoPlayView.isFullScreen ? 0 : visual.margins
            horizontalCenter: parent.horizontalCenter
        }

        sourceComponent: videoPlayView.isFullScreen ?
                             undefined : (isPortrait ?
                                              videoInformation : undefined)
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
            rightMargin: videoPlayView.isFullScreen ?
                             0 : (visual.isE6 ?
                                      visual.margins * 9 : visual.margins * 6)
            verticalCenter: videoPlayView.verticalCenter
        }

        sourceComponent: videoPlayView.isFullScreen ?
                             undefined : (isPortrait ? undefined : videoInformation)
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
            leftMargin: videoPlayView.isFullScreen ?
                            0 : (videoPlayView.width * visual.leftAreaProportion)
            rightMargin: videoPlayView.isFullScreen ?
                             0 : (videoPlayView.width * visual.rightAreaProportion)
        }
    }

    // Slider type of indicator that shows the current volume level.
    VolumeIndicator {
        anchors {
            left: parent.left
            leftMargin: visual.margins
            top: videoPlayerLoader.top
            bottom: videoPlayView.isFullScreen ?
                        overlayLoader.top : videoPlayerLoader.bottom
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
            enableScrubbing: videoPlayView.enableScrubbing

            onBackButtonPressed: {
                __handleExit();
            }

            onPausePressed: {
                videoPlayer.pause();
            }

            onPlayPressed: {
                videoPlayer.play();
            }

            onPlaybackPositionChanged: {
                videoPlayer.setPosition(playbackPosition);
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
        y: parent.height - visual.controlAreaHeight
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
}
