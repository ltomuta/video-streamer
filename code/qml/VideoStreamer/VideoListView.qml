/**
 * Copyright (c) 2012 Nokia Corporation.
 */

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
        }
    }

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: mainPage.listHeight
        snapMode: ListView.SnapToItem

        model: xmlDataModel.status === XmlListModel.Error ? 1 : xmlDataModel

        focus: true
        cacheBuffer: visual.videoListItemHeight*10

        Component {
            id: videoListItemDelegate
            VideoListItem {
                width: listView.width
            }
        }

        Component {
            id: networkErrorItem
            NetworkErrorItem {
                width: listView.width
            }
        }

        delegate: xmlDataModel.status === XmlListModel.Ready
                  ? videoListItemDelegate : networkErrorItem

        // Single header delegate Component.
        header: TitleBar {
            id: titleBar

            height: visual.titleBarHeight
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    ScrollDecorator {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        // flickableItem binds the scroll decorator to the ListView.
        flickableItem: listView
    }

    Loader {
        anchors.centerIn: parent
        height: visual.busyIndicatorHeight
        width: visual.busyIndicatorWidth
        sourceComponent: listView.model.loading ? busyIndicator : undefined

        Component {
            id: busyIndicator

            BusyIndicator {
                running: true
            }
        }
    }
}
