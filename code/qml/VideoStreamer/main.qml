/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import Analytics 1.0
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

        // Analytics: initialize the analytics item with the Application key &
        // version and start gathering analytics events.
        analytics.initialize("13d513e3acc000acad979f7d1b31be21", cp_versionNumber);
    }

    // Create Analytics QML-item and set values for all available optional properties.
    Analytics {
        id: analytics

        connectionTypePreference: Analytics.AnyConnection
        minBundleSize: 20
        loggingEnabled: true
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
        usePlatformPlayer: playerSelectionDlg.selectedIndex === 1
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
            id: backButton

            flat: true
            iconSource: "toolbar-back"
            onPlatformReleased: backButtonTip.opacity = 0;
            onPlatformPressAndHold: backButtonTip.opacity = 1;
            onClicked: {
                if (root.pageStack.depth <= 1) {
                    // Stop gathering the analytics events.
                    analytics.stop("MainScreen", Analytics.AppExit);
                    Qt.quit();
                } else {
                    root.pageStack.pop();
                }
            }
        }
        ToolButton {
            id: searchButton

            flat: true
            iconSource: "toolbar-search"
            onPlatformReleased: searchButtonTip.opacity = 0;
            onPlatformPressAndHold: searchButtonTip.opacity = 1;
            // Create the SearchView to the pageStack dynamically.
            onClicked: pageStack.push(Qt.resolvedUrl("SearchView.qml"),
                                      {pageStack: stack})
        }
        ToolButton {
            id: settingsButton

            flat: true
            iconSource: "toolbar-settings"
            onPlatformReleased: settingsButtonTip.opacity = 0;
            onPlatformPressAndHold: settingsButtonTip.opacity = 1;
            onClicked: playerSelectionDlg.open()
        }
        ToolButton {
            id: aboutButton

            flat: true
            iconSource: visual.images.infoIcon
            onPlatformReleased: aboutButtonTip.opacity = 0;
            onPlatformPressAndHold: aboutButtonTip.opacity = 1;
            onClicked: {
                analytics.logEvent("MainView", "Checked about",
                                   Analytics.ActivityLogEvent);
                pageStack.push(Qt.resolvedUrl("AboutView.qml"),
                               {pageStack: stack});
            }
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

    // The ToolTips have to appear above every view, thus defined here.
    ToolTip {
        id: backButtonTip
        text: qsTr("Back")
        target: backButton
        visible: false
    }

    ToolTip {
        id: searchButtonTip
        text: qsTr("Search")
        target: searchButton
        visible: false
    }

    ToolTip {
        id: settingsButtonTip
        text: qsTr("Settings")
        target: settingsButton
        visible: false
    }

    ToolTip {
        id: aboutButtonTip
        text: qsTr("About")
        target: aboutButton
        visible: false
    }

    StatusBar {
        id: statusbar

        width: parent.width
        visible: root.showStatusBar
        platformInverted: root.platformInverted
    }

    SelectionDialog {
        id: playerSelectionDlg
        selectedIndex: 0
        titleText: qsTr("Select used video player:")

        model: ListModel {
            ListElement { name: "QML Video Player" }
            ListElement { name: "Platform Video Player" }
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }
}
