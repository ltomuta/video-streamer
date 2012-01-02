import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: root

    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack

    property bool platformSoftwareInputPanelEnabled: false

    Component.onCompleted: {
        if (initialPage && stack.depth == 0) {
            stack.push(initialPage, null, true);
        }
        theme.inverted = true;
    }

    // Attribute definitions
    initialPage: VideoListView {
        tools: toolBarLayout
        // Set the height for the VideoListView's list, as hiding / showing
        // the ToolBar prevents the pagestack from being anchored to it.
        listHeight: parent.height-tbar.height
    }

    // VisualStyle has platform differentiation attribute definitions.
    VisualStyle {
        id: visual

        // Bind the layout orientation attribute.
        inPortrait: root.inPortrait
        // Check, whether or not the device is E6
        isE6: root.height == 480
    }

    // Default ToolBarLayout
    ToolBarLayout {
        id: toolBarLayout

        ToolIcon {
            iconId: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"), {pageStack: stack})
        }
        ToolIcon {
            iconSource: visual.images.infoIcon
            onClicked: aboutDlg.open()
        }
    }

    PageStack {
        id: stack
        anchors {
            top: sbar.bottom; bottom: parent.bottom
            left: parent.left; right: parent.right
        }

        clip: true
        toolBar: tbar
    }

    ToolBar {
        id: tbar

        width: parent.width
        visible: root.showToolBar
        anchors.bottom: parent.bottom
        transition: "pop"
    }

    StatusBar {
        id: sbar

        width: parent.width
        visible: root.showStatusBar
    }


    // About dialog
    QueryDialog {
        id: aboutDlg

        titleText: qsTr("YouTube Video Channel")
        message: qsTr("<p>QML VideoStreamer application is a Nokia Developer example " +
                      "demonstrating the QML Video playing capabilies." +
                      "<p>Version: " + cp_versionNumber + "</p>" +
                      "<p>Developed and published by Nokia. All rights reserved.</p>" +
                      "<p>Learn more at " +
                      "<a href=\"http://projects.developer.nokia.com/QMLVideoStreamer\">" +
                      "developer.nokia.com</a>.</p>")
        acceptButtonText: qsTr("Ok")
        onAccepted: {
            // When backing away from the about dialog, return the keyboard
            // focus for the ListView.
            initialPage.forceKeyboardFocus();
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
