/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Slider {
    id: volumeIndicator

    orientation: Qt.Vertical
    maximumValue: 1
    minimumValue: 0
    stepSize: 0.1
    rotation: 180
    opacity: 1
    state: "hide"

    // When the value has changed the indicator is shown, and the hide
    // Timer will be restarted.
    onValueChanged: {
        volumeIndicator.state = "";
        hideTimer.restart();
    }

    Timer {
        id: hideTimer

        interval: 1000
        running: true
        onTriggered: {
            volumeIndicator.state = "hide";
        }
    }

    // Mouse area to grap all the events, as the indicator is not interactive.
    MouseArea {
        anchors.fill: parent
    }

    states: [
        State {
            name: "hide"
            PropertyChanges {
                target: volumeIndicator
                opacity: 0
            }
        }
    ]
    transitions: [
        Transition {
            from: ""
            to: "hide"
            reversible: true
            NumberAnimation {
                property: "opacity"
                duration: visual.animationDurationLong
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
