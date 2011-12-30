import QtQuick 1.1
import com.nokia.meego 1.0
import "util.js" as Util

Item {
    id: container

    height: visual.videoListItemHeight

    // The ListItem's default implementation doesn't handle the Right Key
    // separately, so bind it also to opening the item.
    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Right:
                if (symbian.listInteractionMode != Symbian.KeyNavigation) {
                    symbian.listInteractionMode = Symbian.KeyNavigation;
                } else {
                    container.clicked();
                    event.accepted = true;
                }
                break;
            }
        }
    }

    // Thumbnail Item, with added overlay icon + duration underneath.
    Item {
        id: thumb
        // Reserve 25% of width for the thumb in portrait, and 12% in ls.
        width: visual.inPortrait ? parent.width * 0.25 : parent.width * 0.12
        height: visual.videoImageHeight
        anchors.verticalCenter: parent.verticalCenter

        // Thumbnail image
        Image {
            id: thumbImg

            width: visual.videoImageWidth
            height: visual.videoImageHeight
            anchors.centerIn: parent
            clip: true
            source: m_thumbnailUrl
            fillMode: Image.PreserveAspectCrop
        }
        // Mask image on top of the thumbnail
        Image {
            id: thumbMask
            sourceSize.width: thumbImg.width
            sourceSize.height: thumbImg.height
            anchors.centerIn: thumbImg

            source: visual.images.thumbMask
        }
        // Mask image on top of the thumbnail when the item is selected
        Image {
            id: thumbHilightMask
            source: visual.images.thumbHilightMask
            sourceSize.width: thumbImg.width
            sourceSize.height: thumbImg.height
            anchors.centerIn: thumbImg
            // This hilight mask image is hidden by default.
            opacity: 0

            // The QQC's ListItem has fade-out animation for the selection,
            // so define a similar kind for the thumbnail highlight mask.
            states: [
                State {
                    name: "shown"
                    when: container.mode === "pressed"
                    PropertyChanges {
                        target: thumbHilightMask
                        opacity: 1
                    }
                }
            ]
            transitions: Transition {
                from: "shown"; to: ""
                PropertyAnimation {
                    properties: "opacity"
                    easing.type: Easing.Linear
                    duration: 150
                }
            }
        }
    }

    // And on the right side of the thumb image+duration, lays the information.
    Item {
        width: parent.width - thumb.width
        height: thumbImg.height

        anchors.left: thumb.right
        anchors.top: parent.top
        anchors.topMargin: visual.margins
        anchors.bottom: thumb.bottom

        // Text element for viewing the video title information. Maximum of 2 lines.
        InfoTextLabel {
            id: videoTitle
            text: model.m_title
            width: parent.width
            maximumLineCount: inPortrait ? 2 : 1
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            font.bold: true
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: visual.isE6 ? visual.spacing : 0

            InfoTextLabel {
                id: duration
                width: visual.inPortrait ? parent.width/4 : parent.width/3
                text: Util.secondsToString(model.m_duration)
                anchors.left: parent.left
            }

            // Item bundling the 'eye' icon & views amount together.
            Item {
                id: viewAmount
                height: viewsText.height
                anchors.left: duration.right
                //anchors.right: visual.inPortrait ? undefined : likes.left

                InfoTextLabel {
                    id: viewsText
                    text: model.m_viewCount + qsTr(" views")
                    horizontalAlignment: Text.AlignLeft
                }
            }

            Item {
                id: likes
                width: visual.inPortrait ? parent.width/3 : parent.width/4.2
                anchors.right: parent.right
                anchors.rightMargin: visual.inPortrait ? visual.margins : visual.margins*3

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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var component = Qt.createComponent("VideoPlayView.qml");
            if (component.status == Component.Ready) {
                var player = component.createObject(container);
                pageStack.push(player)
                player.playVideo(model)
            }
        }
    }
}
