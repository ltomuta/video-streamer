// Visual style for Symbian
import QtQuick 1.1

Item {
    // General
    property int margins: 4
    property int spacing: 8

    // Font properties
    property int generalFontSize: platformStyle.fontSizeMedium
    property string defaultFontFamily: "Helvetica"  // Defaults to correct ones in device
    property int defaultFontSize: 14
    property color defaultFontColor: "#45291a"

    // Properties for the ListView
    property int videoImageWidth: 90
    property int videoImageHeight: 90
}
