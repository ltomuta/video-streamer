/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: container

    // Additional properties
    property color gradientStart: visual.gradientStart
    property color gradientEnd: visual.gradientEnd

    // Property value definitions
    height: visual.titleBarHeight

    // Background gradient
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Image {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        source: visual.images.developerLogo
    }
}
