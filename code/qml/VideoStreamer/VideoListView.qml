/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    property int listHeight: parent.height
    property string viewName: "mainView"

    signal playerStart(string url, variant dataModel)

    function forceKeyboardFocus() {
        listView.forceActiveFocus();
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            forceKeyboardFocus();
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
                onClicked: mainPage.playerStart(m_contentUrl, model)
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
