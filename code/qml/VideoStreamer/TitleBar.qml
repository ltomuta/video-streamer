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
        opacity: 0.7
        gradient: Gradient {
            GradientStop { position: 0.0; color: gradientStart }
            GradientStop { position: 1.0; color: gradientEnd }
        }
    }

    Text {
        id: captionText

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: visual.margins
            rightMargin: visual.margins
        }

        font {
            family: visual.defaultFontFamily
            pixelSize: visual.generalFontSize
        }

        color: visual.captionFontColor
        text: qsTr("NOKIA Developer")
        elide: Text.ElideLeft
        horizontalAlignment: Text.AlignLeft
    }
}
