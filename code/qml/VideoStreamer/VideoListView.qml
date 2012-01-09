import QtQuick 1.1
import com.nokia.meego 1.0

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

        model: xmlDataModel
        focus: true
        cacheBuffer: visual.videoListItemHeight*10

        // List item delegate Component.
        delegate: VideoListItem {
            width: listView.width
        }

        // Single header delegate Component.
        header: TitleBar {
            id: titleBar

            height: visual.titleBarHeight
            anchors.top: parent.top
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
                platformStyle: BusyIndicatorStyle { size: "large" }
            }
        }
    }
}
