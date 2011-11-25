// Visual style for Symbian
import QtQuick 1.1

Item {
    // This should be bound from outside (to Window's inPortrait property).
    // The screen orientation will affect how the margins etc. are defined.
    property bool inPortrait: true

    // Property handle to get the style's gfx
    property alias images: images

    // General
    property int margins: 4
    property int spacing: 8

    // Font properties
    property int generalFontSize: platformStyle.fontSizeSmall
    property int largeFontSize: platformStyle.fontSizeLarge
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
    property int controlAreaHeight: 75

    // Busy indicator
    property int busyIndicatorHeight: inPortrait ? screen.width / 4 : screen.height / 4
    property int busyIndicatorWidth: busyIndicatorHeight

    // Video information
    property int informationFieldHorizontalSpacing: 15

    // Visual style's images & graphics
    Item {
        id: images
        property string path: "gfx/"

        property string viewsIcon: path+"views_icon.png"
        property string thumbsUpIcon: path+"thumbs_up.png"
        property string thumbsDownIcon: path+"thumbs_down.png"
    }
}
