import QtQuick 1.1
import com.nokia.symbian 1.1

Window {
    id: root

    // Declared properties
    property bool isShowingSplashScreen: true
    property bool showStatusBar: isShowingSplashScreen ? false : true
    property bool showToolBar: isShowingSplashScreen ? false : true
    property variant splashPage
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

    splashPage: splashComponent

    Component.onCompleted: {
        if (splashPage && stack.depth == 0) {
            stack.push(splashPage, null, true);
        }
    }

    Component {
        id: splashComponent

        Item {
            Splash {
                id: splash
                width: screen.width
                height: screen.height
            }

            BusyIndicator {
                anchors.centerIn: splash
                width: visual.busyIndicatorWidth
                height: visual.busyIndicatorHeight
                running: true
            }

            Connections {
                target: xmlDataModel
                onLoadingChanged: {
                    isShowingSplashScreen = false
                    stack.replace(initialPage)
                }
            }
        }
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
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"), {pageStack: stack})
        }
        ToolButton {
            flat: true
            iconSource: visual.images.infoIcon
            onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"), {tools: aboutTools})
        }
    }

    // ToolBarLayout for AboutView
    ToolBarLayout {
        id: aboutTools

        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
        }
    }

    PageStack {
        id: stack
        anchors {
            top: isShowingSplashScreen ? parent.top : sbar.bottom;
            bottom: parent.bottom
            left: parent.left;
            right: parent.right
        }

        clip: true
        toolBar: tbar
    }

    ToolBar {
        id: tbar

        width: parent.width
        visible: root.showToolBar ? true : false
        anchors.bottom: parent.bottom
        platformInverted: root.platformInverted
    }

    StatusBar {
        id: sbar

        width: parent.width
        visible: root.showStatusBar
        platformInverted: root.platformInverted
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
