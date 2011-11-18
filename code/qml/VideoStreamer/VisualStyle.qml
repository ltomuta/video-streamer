// Visual style for Symbian
import QtQuick 1.1

Item {
    // General
    property int margins: 4
    property int spacing: 8

    // Font properties
    property int generalFontSize: platformStyle.fontSizeSmall
    property string defaultFontFamily: "Helvetica"  // Defaults to correct ones in device
    property color defaultFontColor: "#FFFFFF"

    // Properties for the ListView
    property int videoListItemHeight: 110
    property int videoImageWidth: 90
    property int videoImageHeight: 90

    // For the TitleBar
    property int titleBarHeight: 30
    property color captionFontColor: "#FFFFFF"
    property color gradientStart: "#1C7DCB"
    property color gradientEnd: "#2156B9"

    // Player ViewSection
    property int controlMargins: 10
    property int controlWidth: 50
    property int controlHeight: 50
}
