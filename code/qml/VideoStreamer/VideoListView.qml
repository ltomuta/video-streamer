import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    ListView {
        id: listView
        anchors.fill: parent
        snapMode: ListView.SnapToItem

        model: VideoListModel{}
        delegate: listDelegate
        focus: true
        spacing: visual.spacing

        header: titleDelegate
    }

    Component {
        id: titleDelegate
        TitleBar {
            id: titleBar

            height: visual.titleBarHeight
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    Component {
        id: listDelegate
        VideoListItem {
            width: listView.width
        }
    }
}
