// Visual style for Symbian
import QtQuick 1.1

Item {
    // This should be bound from outside (to Window's inPortrait property).
    // The screen orientation will affect how the margins etc. are defined.
    property bool inPortrait: true

    // E6 has different screen resolution & aspect ratio (640x480), thus
    // there's some differentation for it separately.
    property bool isE6: false

    // Property handle to get the style's gfx
    property alias images: images

    // General
    property int margins: 4
    property int spacing: 8

    // Font properties
    property int smallFontSize: platformStyle.fontSizeSmall
    property int generalFontSize: platformStyle.fontSizeMedium
    property int largeFontSize: platformStyle.fontSizeLarge
    property string defaultFontFamily: "Helvetica"  // Defaults to correct ones in device
    property color defaultFontColor: "#FFFFFF"

    // Properties for the ListView
    property int videoListItemHeight: isE6 ? 90
                                           : (inPortrait ? 80 : 65)
    property int videoImageWidth: inPortrait ? 70 : 60
    property int videoImageHeight: inPortrait ? 70 : 60

    // For the TitleBar
    property int titleBarHeight: 30
    property color captionFontColor: "#FFFFFF"
    property color gradientStart: "#1C7DCB"
    property color gradientEnd: "#2156B9"

    // Player ViewSection
    property int controlMargins: 10
    property int controlWidth: isE6 ? 70 : 50
    property int controlHeight: isE6 ? 70 : 50
    property int controlAreaHeight: isE6 ? 85 : 65

    // Busy indicator
    property int busyIndicatorHeight: inPortrait ? screen.width / 4 : screen.height / 4
    property int busyIndicatorWidth: busyIndicatorHeight

    // Video information
    property int informationFieldHorizontalSpacing: 15
    property int informationFieldVerticalSpacing: 5
    property int informationViewMargins: 5

    // VideoPlayView definitions
    property double topAreaProportion: 0.05
    property double bottomAreaProportion: 0.55

    // Visual style's images & graphics
    Item {
        id: images
        property string path: "gfx/"

        // Background images
        property string portraitBackground: path+"portrait_background.png"
        property string landscapeBackground: path+"landscape_background.png"
        property string durationBackground: path+"duration_background.png"

        property string thumbMask: isE6 ? path+"e6_squircle_thumb_mask.png"
                                        : path+"squircle_thumb_mask.png"
        property string thumbHilightMask: path+"squircle_thumb_hilight_mask.png"
        property string playOverlayIcon: path+"play_overlay_icon.png"
        property string viewsIcon: path+"views_icon.png"
        property string thumbsUpIcon: path+"thumbs_up.png"
        property string thumbsDownIcon: path+"thumbs_down.png"

        property string developerLogo: path+"nokia_developer_logo.png"

        // Extra ToolBar icons
        property string infoIcon: path+"information_userguide.svg"

        // For VideoPlayerControls
        property string vpcBack: path+"back.svg"
        property string vpcPlay: path+"play.svg"
        property string vpcPause: path+"pause.svg"
    }
}
