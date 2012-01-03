import QtQuick 1.1
import com.nokia.meego 1.0

// A Custom made SearchBox, as there is no SearchBox in MeeGo Qt Quick
// Components Extras. It tries to resemble the Symbian extras SearchBox.
Item {
    id: root

    // Styling for the SearchBox
    property Style platformStyle: ToolBarStyle {}
    property alias searchText: searchTextInput.text
    property alias placeHolderText: searchTextInput.placeholderText
    property alias maximumLength: searchTextInput.maximumLength

    // Signals & functions
    signal backClicked()

    // Attribute declarations
    width: parent ? parent.width : 0
    height: bgImage.height


    // SearchBox background.
    BorderImage {
        id: bgImage
        width: root.width
        border.left: 10
        border.right: 10
        border.top: 10
        border.bottom: 10
        source: platformStyle.background
    }

    ToolIcon {
        id: tbBackIcon
        iconId: "toolbar-back"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        onClicked: root.backClicked()
    }

    FocusScope {
        id: textPanel

        anchors.left: tbBackIcon.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: visual.margins * 3
        height: parent.height

        TextField {
            id: searchTextInput

            // Helper function ripped from QQC platform sources. Used for
            // getting the correct URI for the platform toolbar images.
            function __handleIconSource(iconId) {
                var prefix = "icon-m-"
                // check if id starts with prefix and use it as is
                // otherwise append prefix and use the inverted version if required
                if (iconId.indexOf(prefix) !== 0)
                    iconId =  prefix.concat(iconId).concat(theme.inverted ? "-white" : "");
                return "image://theme/" + iconId;
            }

            clip: true
            inputMethodHints: Qt.ImhNoPredictiveText

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: textPanel.verticalCenter
                margins: visual.margins
            }

            platformStyle: TextFieldStyle {
                paddingLeft: searchIcon.width + visual.margins * 2
                paddingRight: clearTextIcon.width
            }

            onActiveFocusChanged: {
                if (!searchTextInput.activeFocus) {
                    searchTextInput.platformCloseSoftwareInputPanel()
                }
            }

            // Search icon, just for styling the SearchBox.
            Image {
                id: searchIcon

                property string __searchIconId: "toolbar-search"

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    margins: visual.margins * 2
                }

                smooth: true
                fillMode: Image.PreserveAspectFit
                source: searchTextInput.__handleIconSource(__searchIconId)
                height: parent.height - visual.margins * 2
                width: parent.height - visual.margins * 2
            }

            // A trash can image, clicking it allows the user to quickly
            // remove the typed text.
            Image {
                id: clearTextIcon

                property string __clearTextIconId: "toolbar-delete"

                anchors {
                    right: parent.right
                    rightMargin: visual.margins
                    verticalCenter: parent.verticalCenter
                }

                smooth: true;
                fillMode: Image.PreserveAspectFit
                source: searchTextInput.__handleIconSource(__clearTextIconId)
                visible: searchTextInput.text.length > 0

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchTextInput.text = ""
                        searchTextInput.forceActiveFocus()
                    }
                }
            }
        }
    }
}
