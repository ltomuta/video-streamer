import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: root

    // Declared properties
    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack
    property bool platformSoftwareInputPanelEnabled: false

    // Attribute definitions
    initialPage: VideoListView {
        tools: toolBarLayout
        // Set the height for the VideoListView's list, as hiding / showing
        // the ToolBar prevents the pagestack from being anchored to it.
        listHeight: parent.height-tbar.height
    }

    Component.onCompleted: {
        if (initialPage && stack.depth == 0) {
            stack.push(initialPage, null, true);
        }
        theme.inverted = true;
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
            onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"), {tools: aboutTools})
        }
    }

    // ToolBarLayout for AboutView
    ToolBarLayout {
        id: aboutTools

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
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
    }

    StatusBar {
        id: sbar

        width: parent.width
        visible: root.showStatusBar
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
