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
        width: visual.inPortrait ? parent.width * 0.27 : parent.width * 0.17
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
    }

    // And on the right side of the thumb image+duration, lays the information.
    Item {
        width: parent.width - thumb.width
        height: thumbImg.height

        anchors.left: thumb.right
        anchors.top: parent.top
        anchors.topMargin: visual.margins

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
        // CURRENTLY DISABLED! RE-ENABLE, IF NEEDED!
        Loader {
            id: loader
//            visible: !visual.inPortrait
//            sourceComponent: visual.inPortrait ? undefined : authorAndDate
            visible: false
            sourceComponent: undefined
            width: parent.width
            anchors.top: videoTitle.bottom

            Component {
                id: authorAndDate

                Item {
                    width: loader.width
                    height: author.height

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

        // Item bundling the duration, eye, 'likes & dislikes' icons & amounts together.
        Item {
            width: parent.width
            height: likesIcon.height
//            anchors.top: visual.inPortrait ? videoTitle.bottom : loader.bottom
            anchors.top: videoTitle.bottom
            anchors.topMargin: visual.margins

            InfoTextLabel {
                id: duration
                width: parent.width/3
                text: Util.secondsToString(model.m_duration)
                anchors.left: parent.left
            }

            // Item bundling the 'eye' icon & views amount together.
            Item {
                id: viewAmount
                height: viewsText.height
                width: visual.inPortrait ? parent.width/4.2 : childrenRect.width
                anchors.left: visual.inPortrait ? duration.right : undefined
                anchors.right: visual.inPortrait ? undefined : likes.left

                InfoTextLabel {
                    id: viewsText
                    text: model.m_viewCount
                    anchors.right: viewsIcon.left
                    anchors.rightMargin: visual.margins
                }
                Image {
                    id: viewsIcon
                    source: visual.images.viewsIcon
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: likes
                width: visual.inPortrait ? parent.width/3 : parent.width/4.2
                anchors.right: parent.right
                anchors.rightMargin: visual.inPortrait ? 0 : visual.margins*3

                InfoTextLabel {
                    id: likesAmount
                    text: model.m_numLikes
                    anchors.right: likesIcon.left
                    anchors.verticalCenter: likesIcon.verticalCenter
                }
                Image {
                    id: likesIcon
                    source: visual.images.thumbsUpIcon
                    anchors.right: dislikesAmount.left
                }
                InfoTextLabel {
                    id: dislikesAmount
                    anchors.right: dislikesIcon.left
                    text: model.m_numDislikes
                    anchors.verticalCenter: dislikesIcon.verticalCenter
                }
                Image {
                    id: dislikesIcon
                    source: visual.images.thumbsDownIcon
                    anchors.right: parent.right
                }
            }
        }
    }
}
