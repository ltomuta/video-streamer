/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.systeminfo 1.1
import QtMultimediaKit 1.1

Item {
    id: videoPlayerContainer

    property alias source: videoPlayerImpl.source
    property alias duration: videoPlayerImpl.duration
    property alias timePlayed: videoPlayerImpl.position
    property alias volume: videoPlayerImpl.volume
    property int timeRemaining: videoPlayerImpl.duration - timePlayed
    property bool isPlaying: false

    signal toggled
    signal playbackStarted

    function play() {
        videoPlayerImpl.play();
    }

    function stop() {
        videoPlayerImpl.stop();
    }

    function pause() {
        videoPlayerImpl.pause();
    }

    function disconnect() {
        volumeConnections.target = null;
    }

    // Sets the playback position to given time (in milliseconds).
    function setPosition(position) {
        videoPlayerImpl.position = position;
    }

    function __volumeUp() {
        var maxVol = 1.0;
        var volThreshold = 0.1;
        if (visual.currentVolume < maxVol - volThreshold) {
            visual.currentVolume += volThreshold;
        } else {
            visual.currentVolume = maxVol;
        }
    }

    function __volumeDown() {
        var minVol = 0.0;
        var volThreshold = 0.1;
        if (visual.currentVolume > minVol + volThreshold) {
            visual.currentVolume -= volThreshold;
        } else {
            visual.currentVolume = minVol;
        }
    }

    function __handleStatusChange(status, playing, position, paused) {
        var isVisibleState = status === Video.Buffered ||
                status === Video.EndOfMedia;
        var isStalled = status === Video.Stalled;

        // Background
        if ( (isVisibleState || isStalled) && !(paused && position === 0) ) {
            blackBackground.opacity = 0;
        } else {
            blackBackground.opacity = 1;
        }

        // Busy indicator
        if (!isVisibleState && playing) {
            busyIndicator.opacity = 1;
        } else {
            busyIndicator.opacity = 0;
        }

        if (status === Video.EndOfMedia) {
            videoPlayerImpl.stop();
            videoPlayerImpl.position = 0;
        }
    }

    Rectangle {
        id: videoBackground

        color: "#000000"
        z: videoPlayerImpl.z - 1
        anchors.fill: parent
    }

    DeviceInfo {
        id: deviceInfo

        monitorCurrentProfileChanges: true

        onCurrentProfileChanged: {
            // Update volume dynamically when profile is changed.
            // Binding Video element volume directly to voiceRingtoneVolume
            // sets only initial volume but value is not updated correctly.
            visual.currentVolume = deviceInfo.voiceRingtoneVolume / 100;
        }
    }

    Video {
        id: videoPlayerImpl

        property bool playbackStarted: false

        volume: visual.currentVolume
        autoLoad: true
        anchors.fill: parent
        fillMode: Video.PreserveAspectFit
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                videoPlayerContainer.toggled()
            }
        }

        onPlayingChanged: {
            videoPlayerContainer.isPlaying = playing
            __handleStatusChange(status, isPlaying, position, paused)
        }
        onPausedChanged: {
            videoPlayerContainer.isPlaying = !paused
            __handleStatusChange(status, isPlaying, position, paused)
        }

        onStatusChanged: {
            if (status === Video.Buffered && !videoPlayerImpl.playbackStarted) {
                videoPlayerImpl.playbackStarted = true;
                videoPlayerContainer.playbackStarted();
            }

            __handleStatusChange(status, isPlaying, position, paused)
        }
    }

    Rectangle {
        id: blackBackground

        anchors.fill: parent
        color: "#000000"
        z: videoPlayerImpl.z + 1
        opacity: 1
    }

    BusyIndicator {
        id: busyIndicator

        anchors.centerIn: blackBackground
        height: visual.busyIndicatorHeight
        width: visual.busyIndicatorWidth
        z: blackBackground.z + 1
        running: true
    }

    Connections {
        id: volumeConnections

        target: volumeKeys
        onVolumeKeyUp: __volumeUp()
        onVolumeKeyDown: __volumeDown()
    }
}
