/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import "VideoPlayer/util.js" as Util

Item {
    id: container

    // Attribute definitions
    height: visual.videoListItemHeight


    // Custom made background highlight, as there's no ListItem in Qt Quick
    // MeeGo components. Graphics ripped from QQC Symbian project.
    BorderImage {
        id: highlight
        border {
            left: visual.margins
            top: visual.margins
            right: visual.margins
            bottom: visual.margins
        }
        opacity: 0
        anchors.fill: parent
        source: visual.images.listItemHilight

        states: [
            State {
                name: "shown"
                when: ma.pressed
                PropertyChanges {
                    target: highlight
                    opacity: 1
                }
            }
        ]
        transitions: Transition {
            from: "shown"; to: ""
            PropertyAnimation {
                properties: "opacity"
                easing.type: Easing.Linear
                duration: visual.animationDurationShort
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
        // Mask image on top of the thumbnail when the item is selected.
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
                    name: "pressed"
                    when: ma.pressed
                    PropertyChanges {
                        target: thumbHilightMask
                        opacity: 1
                    }
                }
            ]
            transitions: Transition {
                from: "pressed"; to: ""
                PropertyAnimation {
                    properties: "opacity"
                    easing.type: Easing.Linear
                    duration: visual.animationDurationShort
                }
            }
        }
    }

    // And on the right side of the thumb image+duration, lays the information.
    Item {
        width: parent.width - thumb.width
        height: thumbImg.height

        anchors {
            left: thumb.right
            top: parent.top
            topMargin: visual.margins
            bottom: thumb.bottom
        }

        // Text element for viewing the video title information.
        // Maximum of 2 lines.
        InfoTextLabel {
            id: videoTitle

            text: model.m_title
            width: parent.width
            maximumLineCount: inPortrait ? 2 : 1
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            font.bold: true
        }

        // Item bundling the duration, eye, 'likes & dislikes' icons
        // and amounts together.
        Item {
            width: parent.width
            height: duration.height
            anchors {
                bottom: parent.bottom
                bottomMargin: visual.isE6 ? visual.spacing : 0
            }

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
                anchors {
                    left: duration.right
                    right: parent.right
                }

                InfoTextLabel {
                    id: viewsText

                    text: model.m_viewCount + qsTr(" views")
                    horizontalAlignment: Text.AlignRight
                    anchors {
                        right: parent.right
                        rightMargin: visual.inPortrait
                                     ? visual.margins*2 : visual.margins*3
                    }
                }
            }
        }
    }

    MouseArea {
        id: ma

        anchors.fill: parent

        onClicked: {
            var component = Qt.createComponent("VideoPlayPage.qml");
            if (component.status === Component.Ready) {
                var player = component.createObject(container);
                pageStack.push(player)

                // setVideoData expects parameter to contain video data
                // information properties. Expected properties are identical to
                // used XmlListModel.
                player.setVideoData(model)
            }
        }
    }
}

//        // Author and date published information are only shown in landscape.
//        // CURRENTLY DISABLED! RE-ENABLE, IF NEEDED!
//        Loader {
//            id: loader
//
//            visible: !visual.inPortrait
//            sourceComponent: visual.inPortrait ? undefined : authorAndDate
//            visible: false
//            sourceComponent: undefined
//
//            width: parent.width
//            anchors.top: videoTitle.bottom
//
//            Component {
//                id: authorAndDate
//
//                Item {
//                    width: loader.width
//                    height: author.height
//
//                    InfoTextLabel {
//                        id: author
//                        text: qsTr("By ") + model.m_author
//                        anchors.top: parent.top
//                        anchors.left: parent.left
//                    }
//                    InfoTextLabel {
//                        id: date
//                        text: Util.formatDate(model.m_uploaded)
//                        anchors {
//                            left: author.right
//                            right: parent.right
//                            rightMargin: visual.margins*3
//                        }
//                        horizontalAlignment: Text.AlignRight
//                    }
//                }
//            }
//        }
//
//            // Likes & dislikes are currently being disabled. Re-enable by
//            // uncommenting the following lines, re-anchoring the viewAmount.
//            Item {
//                id: likes
//                width: visual.inPortrait ? parent.width/3 : parent.width/4.2
//                anchors.right: parent.right
//                anchors.rightMargin: visual.inPortrait ? visual.margins : visual.margins*3
//
//                InfoTextLabel {
//                    id: likesAmount
//                    text: model.m_numLikes ? model.m_numLikes : "0"
//                    anchors.right: likesIcon.left
//                    anchors.verticalCenter: likesIcon.verticalCenter
//                }
//                Image {
//                    id: likesIcon
//                    source: visual.images.thumbsUpIcon
//                    anchors.right: dislikesAmount.left
//                }
//                InfoTextLabel {
//                    id: dislikesAmount
//                    anchors.right: dislikesIcon.left
//                    text: model.m_numDislikes ? model.m_numDislikes : "0"
//                    anchors.verticalCenter: dislikesIcon.verticalCenter
//                }
//                Image {
//                    id: dislikesIcon
//                    source: visual.images.thumbsDownIcon
//                    anchors.right: parent.right
//                }
//            }
