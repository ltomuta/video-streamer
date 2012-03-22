/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import Analytics 1.0
import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    property int listHeight: parent.height

    function forceKeyboardFocus() {
        listView.forceActiveFocus();
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            mainPage.forceKeyboardFocus();
            analytics.start("MainView");
        } else if (status === PageStatus.Deactivating) {
            analytics.stop("MainView", Analytics.SessionCloseReason);
        }
    }

    ListView {
        id: listView

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: mainPage.listHeight
        snapMode: ListView.SnapToItem
        focus: true

        onHeaderChanged: {
            // Since the delegate is being binded to XmlListModel's status
            // (XmlListModel.Ready), the header will not be shown correctly
            // during startup. Thus positioning the list correctly, once the
            // correct delegate has been finally loaded.
            listView.positionViewAtBeginning();
        }

        // Set the header, delegate & model attributes after the model
        // has either loaded or failed loading. I.e. show items or error msg.
        Connections {
            target: xmlDataModel
            onModelReady: {
                listView.model = xmlDataModel;
                listView.header = titleBar;
                listView.delegate = videoListItemDelegate;
            }
            onModelError: {
                listView.model = 1;
                listView.header = titleBar;
                listView.delegate = networkErrorItem;
            }
        }

        Component {
            id: titleBar

            TitleBar {
                height: visual.titleBarHeight
                width: listView.width
            }
        }

        Component {
            id: videoListItemDelegate

            VideoListItem {
                width: listView.width

                onClicked: {
                    if (visual.usePlatformPlayer) {
                        playerLauncher.launchPlayer(m_contentUrl)
                        // Analytics: log the player launch event with "platformPlayer".
                        analytics.logEvent("MainView", "PlatformPlayer launch",
                                           Analytics.ActivityLogEvent);
                    } else {
                        var component = Qt.createComponent("VideoPlayPage.qml");
                        if (component.status === Component.Ready) {
                            // Instanciate the VideoPlayPage Element here. It will take care
                            // of destructing it itself.
                            var player = component.createObject(parent);
                            pageStack.push(player);

                            // setVideoData expects parameter to contain video data
                            // information properties. Expected properties are identical to
                            // used XmlListModel.
                            player.setVideoData(model);

                            // Analytics: log the player launch event with "QMLVideoPlayer".
                            analytics.logEvent("MainView", "QMLVideoPlayer launch",
                                               Analytics.ActivityLogEvent);
                        }
                    }
                }
            }
        }

        Component {
            id: networkErrorItem

            NetworkErrorItem {
                width: listView.width
            }
        }
    }

    ScrollDecorator {
        // flickableItem binds the scroll decorator to the ListView.
        flickableItem: listView
    }
}
