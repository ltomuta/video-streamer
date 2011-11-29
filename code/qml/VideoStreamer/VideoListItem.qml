import QtQuick 1.1
import com.nokia.symbian 1.1
import "util.js" as Util

ListItem {
    id: container

    height: visual.videoListItemHeight

    onClicked: {
        var component = Qt.createComponent("VideoPlayView.qml");
        if (component.status == Component.Ready) {
            var player = component.createObject(container);
            pageStack.push(player)
            player.playVideo(model)
        }
    }

    // Thumbnail Item, with added overlay icon + duration underneath.
    Item {
        id: thumb
        // Reserve 30% of width for the thumb in portrait, and 17% in ls.
        width: visual.inPortrait ? parent.width * 0.3 : parent.width * 0.17
        height: visual.videoImageWidth
        anchors.top: parent.top

        // Thumbnail image
        Image {
            id: thumbImg

            width: visual.videoImageWidth
            height: visual.videoImageHeight
            anchors.left: parent.left
            clip: true
            source: m_thumbnailUrl
            fillMode: Image.PreserveAspectCrop
        }
        // Mask image on top of the thumbnail
        Image {
            width: thumbImg.width
            height: thumbImg.height
            anchors.centerIn: thumbImg

            source: visual.images.thumbMask
        }

        // BG image for the duration label (so that the hilight wouldn't
        // be shown partly over the duration, but not over the thumb).
        Image {
            width: thumbImg.width
            anchors.left: thumbImg.left
            anchors.top: thumbImg.bottom

            source: visual.images.durationBackground
        }

        InfoTextLabel {
            id: duration
            text: Util.secondsToString(model.m_duration)
            anchors.top: thumbImg.bottom
            anchors.horizontalCenter: thumbImg.horizontalCenter
            verticalAlignment: Text.AlignTop
        }
    }

    // And on the right side of the thumb image+duration, lays the information.
    Item {
        width: parent.width - thumb.width
        height: thumbImg.height

        anchors.left: thumb.right
        // Text element for viewing the video title information. Maximum of 2 lines.
        InfoTextLabel {
            id: videoTitle
            text: model.m_title
            width: parent.width
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        // Author and date published information are only shown in landscape.
        Loader {
            id: loader
            visible: !visual.inPortrait
            width: parent.width
            sourceComponent: visual.inPortrait ? undefined : authorAndDate
            anchors.top: videoTitle.bottom

            Component {
                id: authorAndDate

                Item {
                    width: loader.width
                    height: 2*author.height

                    InfoTextLabel {
                        id: author
                        text: qsTr("By ") + model.m_author
                        anchors.top: parent.top
                        anchors.left: parent.left
                    }
                    InfoTextLabel {
                        id: date
                        text: Util.formatDate(model.m_uploaded)
                        anchors {
                            left: author.right
                            right: parent.right
                            rightMargin: visual.margins*3
                        }
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }

        // The positioning of the likes&dislikes and the views amount depends
        // on the device orientation. In portrait they're on top of each other
        // and in landscape they're side by side.
        Grid {
            width: parent.width
            rows: visual.inPortrait ? 2 : 1
            columns: visual.inPortrait ? 1 : 2
            anchors.top: visual.inPortrait ? videoTitle.bottom : loader.bottom

            // Item bundling the 'likes & dislikes' icons & amounts together.
            Item {
                width: childrenRect.width
                height: likesIcon.height

                InfoTextLabel {
                    id: likesAmount
                    text: model.m_numLikes
                    anchors.left: parent.left
                    anchors.verticalCenter: likesIcon.verticalCenter
                }
                Image {
                    id: likesIcon
                    source: visual.images.thumbsUpIcon
                    anchors.left: likesAmount.right
                }
                InfoTextLabel {
                    id: dislikesAmount
                    anchors.left: likesIcon.right
                    text: model.m_numDislikes
                    anchors.verticalCenter: dislikesIcon.verticalCenter
                }
                Image {
                    id: dislikesIcon
                    source: visual.images.thumbsDownIcon
                    anchors.left: dislikesAmount.right
                }
            }

            // Item bundling the 'eye' icon & views amount together.
            Item {
                id: viewAmount
                width: parent.width
                height: viewsText.height

                Image {
                    id: viewsIcon
                    source: visual.images.viewsIcon
                    anchors.verticalCenter: parent.verticalCenter
                }
                InfoTextLabel {
                    id: viewsText
                    anchors.left: viewsIcon.right
                    anchors.leftMargin: visual.margins
                    text: model.m_viewCount
                }
            }
        }
    }
}
