/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1

Item {
    id: errorItem

    anchors.fill: parent

    InfoTextLabel {
        anchors {
            fill: parent
            margins: visual.margins
        }
        text: qsTr("No network connection available. Please check your device's internet connections.")
        wrapMode: Text.WordWrap
    }
}
