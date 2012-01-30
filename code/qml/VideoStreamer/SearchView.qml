import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: searchView

    // Declared properties
    property variant pageStack

    SearchBox {
        id: searchbox

        placeHolderText: qsTr("Search Text")
        onBackClicked: searchView.pageStack.depth <= 1 ?
                           Qt.quit() : searchView.pageStack.pop()
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

        model: xmlDataModel.status === XmlListModel.Error ?
                   1 : (searchbox.searchText ? videoListModel : null)
        snapMode: ListView.SnapToItem
        cacheBuffer: visual.videoListItemHeight*10
        clip: true

        // List item delegate Component.
        Component {
            id: videoListItem
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

        delegate: xmlDataModel.status === XmlListModel.Error ?
                      networkErrorItem : videoListItem
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

    Text {
        id: noResultsText

        font {
            family: visual.defaultFontFamily
            pixelSize: visual.largeFontSize
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchbox.bottom
        opacity: 0
        color: visual.defaultFontColor
        text: qsTr("No videos found")
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
}
