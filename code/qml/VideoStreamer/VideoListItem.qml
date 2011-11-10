import QtQuick 1.1
import com.nokia.symbian 1.1

ListItem {
    id: container

    height: 92
//    property int margins: 8
//    property int spacing: 8
//    property string fontName: "Helvetica"
//    property int titleFontSize: 12
//    property int fontSize: 10
//    property color fontColorTitle: "black"

    Row {
        anchors.fill: parent

        Item {
            id: thumb
            width: parent.width * 0.3   // Reserve 30% of width for the thumb
            height: parent.height

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
                width: thumb.width
                height: thumb.height
                anchors.centerIn: thumbImg

                source: "gfx/squircle_thumb_mask.png"
            }
        }

        Column {
            width: parent.width - thumb.width //appState.inLandscape ? parent.width * 0.9 : parent.width * 0.8
            height: thumbImg.height

            Text {
                id: videoTitle
                width: parent.width

                maximumLineCount: 2
                text: model.m_title
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
            Text {
                id: videoLength
                text: model.m_duration + qsTr(" seconds, by ") + model.m_author
            }

            Text {
                id: viewAmount
                text: model.m_viewCount + qsTr(" views")
            }

            Text {
                id: likesAmount
                text: model.m_numLikes + qsTr(" likes ") + model.m_numDislikes + qsTr(" dislikes")
//                font {
//                    family: container.fontName
//                    pointSize: container.fontSize
//                }
//                color: container.fontColor
            }
        }
    }
}
