import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Page {
    id: searchView

    property variant pageStack

    SearchBox {
        id: searchbox

        focus: true
        placeHolderText: qsTr("Search Text")
        backButton: true
        onBackClicked: searchView.pageStack.depth <= 1 ? Qt.quit() : searchView.pageStack.pop()
    }

    VideoListModel {
        id: videoListModel

        searchTerm: searchbox.searchText
    }

    ListView {
        id: listView
        anchors {
            top: searchbox.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        snapMode: ListView.SnapToItem
        model: searchbox.searchText ? videoListModel : null
        delegate: listDelegate
        focus: true
        spacing: visual.spacing
        clip: true
    }

    Component {
        id: listDelegate
        VideoListItem {
            width: listView.width
        }
    }

    states: State {
        name: "NoResults"
        when: (videoListModel.searchTerm &&
               videoListModel.count <= 0 &&
               videoListModel.status === XmlListModel.Ready)

        PropertyChanges {
            target: noResultsText
            opacity: 1
        }
    }

    Text {
        id: noResultsText
        text: qsTr("No videos found")

        font {
            family: visual.defaultFontFamily
            pixelSize: visual.largeFontSize
        }
        color: visual.defaultFontColor

        opacity: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchbox.bottom
    }
}
