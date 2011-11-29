import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    ListView {
        id: listView
        anchors.fill: parent
        snapMode: ListView.SnapToItem

        model: VideoListModel{}
        focus: true
        spacing: visual.spacing
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
}
