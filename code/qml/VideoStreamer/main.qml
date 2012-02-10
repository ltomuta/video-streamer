/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import Qt.labs.components 1.1
import QtMobility.systeminfo 1.1
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
        listHeight: parent.height - toolbar.height
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

            function __hideSplash() {
                busy.opacity = 0;
                root.isShowingSplashScreen = false;
                stack.push(initialPage);
            }

            width: root.width
            height: root.height
            // Get rid of the fake splash for good, when loading is done!
            onDismissed: busySplash.destroy();

            Component.onCompleted: {
                if (xmlDataModel.status === XmlListModel.Error) {
                    __hideSplash();
                }
            }

            Connections {
                target: xmlDataModel
                onStatusChanged: {
                    if (xmlDataModel.status === XmlListModel.Ready ||
                            xmlDataModel.status === XmlListModel.Error) {
                        __hideSplash();
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

        // Set the initial volume level (from the device's profile)
        DeviceInfo {id: devInfo}
        currentVolume: devInfo.voiceRingtoneVolume / 100
        // Track, which player is being used.
        usePlatformPlayer: checkableGroup.selectedValue ===
                           platformPlayerButton.text
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

        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: root.pageStack.depth <= 1 ?
                           Qt.quit() : root.pageStack.pop()
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-search"
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"),
                                      {pageStack: stack})
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-settings"
            onClicked: playerSelectionDlg.open()
        }
        ToolButton {
            flat: true
            iconSource: visual.images.infoIcon
            onClicked: pageStack.push(Qt.resolvedUrl("AboutView.qml"),
                                      {pageStack: stack})
        }
    }

    PageStack {
        id: stack

        anchors {
            top: statusbar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        clip: true
        toolBar: toolbar
    }

    ToolBar {
        id: toolbar

        width: parent.width
        visible: root.showToolBar ? true : false
        anchors.bottom: parent.bottom
        platformInverted: root.platformInverted
    }

    StatusBar {
        id: statusbar

        width: parent.width
        visible: root.showStatusBar
        platformInverted: root.platformInverted
    }

    QueryDialog {
        id: playerSelectionDlg

        acceptButtonText: qsTr("Ok")
        titleText: qsTr("Select used video player:")

        content: Item {
            height: buttonColumn.height
            CheckableGroup { id: checkableGroup }
            Column {
                id: buttonColumn
                spacing: platformStyle.paddingMedium
                RadioButton {
                    id: qmlPlayerButton
                    text: qsTr("QML Video Player")
                    platformExclusiveGroup: checkableGroup
                }
                RadioButton {
                    id: platformPlayerButton
                    text: qsTr("Platform Video Player")
                    platformExclusiveGroup: checkableGroup
                }
            }
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
