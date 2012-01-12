import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: container

    property variant pageStack
    
    // Background gradient
    Rectangle {
        id: logo

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: visual.titleBarHeight
        color: "white"

        Image {
            id: logoImg

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: visual.images.developerLogo
        }
    }

    // Label for the application.
    InfoTextLabel {
        id: titleText

        anchors {
            top: logo.bottom
            topMargin: visual.margins*3
            left: parent.left
            leftMargin: visual.margins
        }
        width: parent.width
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: visual.largeFontSize
        font.bold: true
        text: qsTr("YouTube Video Channel")
    }

    // Some about text & application information.
    InfoTextLabel {
        id: aboutText

        anchors {
            margins: visual.margins*2
            left: parent.left
            right: parent.right
            top: titleText.bottom
        }

        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: qsTr("<p>QML VideoStreamer application is a Nokia Developer example " +
                   "demonstrating the QML Video playing capabilies." +
                   "<p>Version: " + cp_versionNumber + "</p>" +
                   "<p>Developed and published by Nokia. All rights reserved.</p>" +
                   "<p>Learn more at " +
                   "<a href=\"http://projects.developer.nokia.com/QMLVideoStreamer\">" +
                   "developer.nokia.com</a>.</p>")

        onLinkActivated: {
            console.log("Launched url " + link);
            Qt.openUrlExternally(link);
        }
    }

    // ToolBarLayout for AboutView
    tools: ToolBarLayout {
        id: aboutTools

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: container.pageStack.depth <= 1 ?
                           Qt.quit() : container.pageStack.pop()
        }
    }
}
