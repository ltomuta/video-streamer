/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import Analytics 1.0
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

Page {
    id: searchView

    // Declared properties
    property variant pageStack
    property string viewName: "searchView"
    
    // If the user moves up/down, focus on the list instead of the search box.
    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Up:
            case Qt.Key_Down:
                // Don't accept the event, just set the focus to the list.
                // The ListItems themselves will accept the kb events.
                listView.forceActiveFocus();
                break;
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            // Analytics: start gathering analytics events for the SearchView.
            analytics.start(searchView.viewName);
        } else if (status === PageStatus.Deactivating) {
            // Analytics: Stop measuring & logging events for SearchView.
            analytics.stop(searchView.viewName, Analytics.EndSession);
        }
    }

    SearchBox {
        id: searchbox

        placeHolderText: qsTr("Search Text")
        backButton: true
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

        snapMode: ListView.SnapToItem
        cacheBuffer: visual.videoListItemHeight*10
        clip: true

        model: xmlDataModel.status === XmlListModel.Error ?
                   1 : (searchbox.searchText ? videoListModel : null)
        delegate: xmlDataModel.status === XmlListModel.Error ?
                      networkErrorItem : videoListItem

        // List item delegate Component.
        Component {
            id: videoListItem

            VideoListItem {
                width: listView.width

                onClicked: {
                    if (visual.usePlatformPlayer) {
                        // Analytics: log the player launch event with "platformPlayer".
                        analytics.logEvent(searchView.viewName, "PlatformPlayer launch",
                                           Analytics.ActivityLogEvent);

                        playerLauncher.launchPlayer(m_contentUrl);
                    } else {
                        // Analytics: log the player launch event with "QMLVideoPlayer".
                        analytics.logEvent(searchView.viewName, "QMLVideoPlayer launch",
                                           Analytics.ActivityLogEvent);

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
                        }
                    }
                }
            }
        }

        // Delegate, that's shown when there's been an error in network communication.
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

    Text {
        id: noResultsText

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: searchbox.bottom
        }

        font {
            family: visual.defaultFontFamily
            pixelSize: visual.largeFontSize
        }

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
