/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "VideoPlayer/util.js" as Util

ListItem {
    id: container

    // Attribute definitions
    height: visual.videoListItemHeight

    // The ListItem's default implementation doesn't handle the Right Key
    // separately, so bind it also to opening the item.
    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Right:
                if (symbian.listInteractionMode !== Symbian.KeyNavigation) {
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
        // Mask image on top of the thumbnail when the item is selected.
        Image {
            id: thumbHilightMask

            // The image is being variated based on with which method
            // it is being selected.
            source: (container.mode === "pressed" || container.mode === "normal" ) ?
                        visual.images.thumbHilightMask      // Selected with touch
                      : visual.images.thumbKbHilightMask    // Selected with KB

            sourceSize.width: thumbImg.width
            sourceSize.height: thumbImg.height
            anchors.centerIn: thumbImg
            // This hilight mask image is hidden by default.
            opacity: 0

            states: [
                State {
                    name: "pressed"
                    when: container.mode === "pressed"
                    PropertyChanges {
                        target: thumbHilightMask
                        opacity: 1
                    }
                },
                State {
                    name: "highlighted"
                    when: container.mode === "highlighted"
                    PropertyChanges {
                        target: thumbHilightMask
                        opacity: 1
                    }
                }
            ]

            // The QQC's ListItem has fade-out animation for the selection,
            // so define a similar kind for the thumbnail highlight mask.
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
