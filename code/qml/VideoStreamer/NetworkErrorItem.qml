import QtQuick 1.1

Item {
    id: errorItem

    anchors.fill: parent

    InfoTextLabel {
        anchors.fill: parent
        anchors.margins: visual.margins
        text: qsTr("No network connection available. Please check your settings")
        wrapMode: Text.WordWrap
    }
}
