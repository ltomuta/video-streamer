import QtQuick 1.1
import com.nokia.symbian 1.1

Window {
    id: root

    // Declared properties
    property bool isShowingSplashScreen: true
    property bool showStatusBar: !isShowingSplashScreen
    property bool showToolBar: !isShowingSplashScreen
    property variant initialPage
    property variant busySplash
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
        // Instantiate the Fake Splash Component. Shows a busy indicator for
        // as long as the xml data model keeps loading.
        var comp = busySplashComp;
        if (comp.status === Component.Ready) {
            busySplash = comp.createObject(root);
        }
    }

    Component {
        id: busySplashComp

        BusySplash {
            id: busy
            width: root.width
            height: root.height

            // Get rid of the fake splash for good, when loading is done!
            onDismissed: busySplash.destroy();

            Connections {
                target: xmlDataModel
                onLoadingChanged: {
                    busy.opacity = 0;
                    root.isShowingSplashScreen = false;
                    stack.push(initialPage);
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
            top: sbar.bottom; bottom: parent.bottom
            left: parent.left; right: parent.right
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
