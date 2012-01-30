import QtQuick 1.1
import com.nokia.meego 1.0
import "VideoPlayer"

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
        // Use the black theme on MeeGo.
        theme.inverted = true;
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

            function __hideSplash() {
               busy.opacity = 0;
               root.isShowingSplashScreen = false;
               stack.push(initialPage);
           }

            // Get rid of the fake splash for good, when loading is done!
            onDismissed: busySplash.destroy();

            Component.onCompleted: {
                if (xmlDataModel.status === XmlListModel.Error) {
                    __hideSplash()
                }
            }

            Connections {
                target: xmlDataModel
                onStatusChanged: {
                    if (xmlDataModel.status === XmlListModel.Ready ||
                        xmlDataModel.status === XmlListModel.Error) {
                        __hideSplash()
                    }
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

    // Background, shown behind the lists. Will fade to black when hiding it.
    Image {
        id: backgroundImg
        anchors.fill: parent
        source: visual.inPortrait ?
                    (visual.showBackground ?
                         visual.images.portraitListBackground
                       : visual.images.portraitVideoBackground)
                  : (visual.showBackground ?
                         visual.images.landscapeListBackground
                       : visual.images.landscapeVideoBackground)
    }

    // Default ToolBarLayout
    ToolBarLayout {
        id: toolBarLayout

        ToolIcon {
            iconId: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"),
                                      {pageStack: stack})
        }
        ToolIcon {
            iconSource: visual.images.infoIcon
            onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"),
                                      {pageStack: stack})
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
