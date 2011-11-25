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

    Row {
        anchors.fill: parent

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

                source: "gfx/squircle_thumb_mask.png"
            }

            Text {
                id: duration
                text: Util.secondsToString(model.m_duration)
                anchors.top: thumbImg.bottom
                anchors.horizontalCenter: thumbImg.horizontalCenter
                verticalAlignment: Text.AlignTop
                font {
                    family: visual.defaultFontFamily
                    pixelSize: visual.generalFontSize
                }
                color: visual.defaultFontColor
            }
        }

        Column {
            width: parent.width - thumb.width //visual.inPortrait ? parent.width * 0.9 : parent.width * 0.8
            height: thumbImg.height

            // Text element for viewing the video title information. Maximum of 2 lines.
            Text {
                id: videoTitle
                text: model.m_title
                width: parent.width
                font {
                    family: visual.defaultFontFamily
                    pixelSize: visual.generalFontSize
                }
                color: visual.defaultFontColor
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }

            Loader {
                id: loader
                visible: !visual.inPortrait
                width: parent.width
                sourceComponent: Component {
                    Item {
                        width: loader.width
                        height: 2*author.height

                        Text {
                            id: author
                            text: qsTr("By ") + model.m_author
                            anchors.top: parent.top
                            anchors.left: parent.left
                            font {
                                family: visual.defaultFontFamily
                                pixelSize: visual.generalFontSize
                            }
                            color: visual.defaultFontColor
                        }
                        Text {
                            id: date
                            text: "11/11/2011"
                            anchors {
                                left: author.right
                                right: parent.right
                                rightMargin: visual.margins*3
                            }
                            horizontalAlignment: Text.AlignRight
                            font {
                                family: visual.defaultFontFamily
                                pixelSize: visual.generalFontSize
                            }
                            color: visual.defaultFontColor
                        }
                    }
                }
            }

            Grid {
                width: parent.width
                rows: visual.inPortrait ? 2 : 1
                columns: visual.inPortrait ? 1 : 2

                // Item bundling the 'likes & dislikes' icons & amounts together.
                Row {
                    Text {
                        id: likesAmount
                        text: model.m_numLikes
                        font {
                            family: visual.defaultFontFamily
                            pixelSize: visual.generalFontSize
                        }
                        color: visual.defaultFontColor
                    }
                    Image {
                        id: likesIcon
                        source: visual.images.thumbsUpIcon
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: dislikesAmount
                        text: model.m_numDislikes
                        font {
                            family: visual.defaultFontFamily
                            pixelSize: visual.generalFontSize
                        }
                        color: visual.defaultFontColor
                    }
                    Image {
                        id: dislikesIcon
                        source: visual.images.thumbsDownIcon
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Item bundling the 'eye' icon & views amount together.
                Item {
                    id: viewAmount
                    width: parent.width
                    height: viewsText.height
                    //anchors.left: parent.left

                    Image {
                        id: viewsIcon
                        source: visual.images.viewsIcon
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: viewsText
                        anchors.left: viewsIcon.right
                        anchors.leftMargin: visual.margins
                        text: model.m_viewCount
                        font {
                            family: visual.defaultFontFamily
                            pixelSize: visual.generalFontSize
                        }
                        color: visual.defaultFontColor
                    }
                }
            }
        }
    }
}
