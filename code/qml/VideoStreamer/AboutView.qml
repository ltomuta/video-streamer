// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

Page {

    // Label for the application.
    InfoTextLabel {
        id: titleText

        anchors.top: parent.top
        anchors.topMargin: visual.margins
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: visual.largeFontSize
        font.bold: true
        text: qsTr("YouTube Video Channel")
    }

    // Some about text & application information.
    InfoTextLabel {
        id: aboutText

        anchors {
            margins: visual.margins
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
}
