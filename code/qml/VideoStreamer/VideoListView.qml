import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    ListView {
        id: listView
        anchors {
            top: titleBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        model: VideoListModel{}
        delegate: listDelegate
        focus: true
        spacing: visual.spacing
    }

    TitleBar {
        id: titleBar

        height: 30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Component {
        id: listDelegate
        VideoListItem {
            width: listView.width
        }
    }
}
