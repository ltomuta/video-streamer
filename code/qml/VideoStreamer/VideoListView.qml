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

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: mainPage.listHeight
        snapMode: ListView.SnapToItem
        focus: true
        cacheBuffer: visual.videoListItemHeight*10

        model: xmlDataModel.status === XmlListModel.Error ? 1 : xmlDataModel
        delegate: xmlDataModel.status === XmlListModel.Ready
                  ? videoListItemDelegate : networkErrorItem

        // Single header delegate Component.
        header: TitleBar {
            id: titleBar

            height: visual.titleBarHeight
            anchors {
                left: parent.left
                right: parent.right
            }
        }

        onDelegateChanged: {
            // Since the delegate is being binded to XmlListModel's status
            // (XmlListModel.Ready), the header will not be shown correctly
            // during startup. Thus positioning the list correctly, once the
            // correct delegate has been finally loaded.
            listView.positionViewAtBeginning();
        }

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
    }

    ScrollDecorator {
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
