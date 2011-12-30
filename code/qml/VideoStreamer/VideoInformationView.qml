import QtQuick 1.0
import com.nokia.symbian 1.1
import "util.js" as Util



Item {
    id: videoInformationView

    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0

    function __prependToLength(text, len, fill) {
        text = text.toString()
        fill = fill.toString()
        var diff = len - text.length
        for (var index = 0; index < diff; index++) {
            text = fill.concat(text)
        }

        return text
    }

    anchors.margins: visual.informationViewMargins

    // Bundle each text label & image as a pair.
    Item {
        id: likes
        anchors.left: parent.left
        anchors.leftMargin: visual.margins
        height: childrenRect.height

        InfoTextLabel {
            id: likesLabel
            text: videoInformationView.__prependToLength(videoInformationView.numLikes, 4, 0)
        }

        Image {
            source: visual.images.thumbsUpIcon
            anchors {
                left: likesLabel.right
                leftMargin: visual.margins
                verticalCenter: likesLabel.verticalCenter
            }
        }
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: childrenRect.width

        InfoTextLabel {
            id: dislikesLabel
            text: videoInformationView.__prependToLength(videoInformationView.numDislikes, 4, 0)
        }

        Image {
            source: visual.images.thumbsDownIcon
            anchors {
                left: dislikesLabel.right
                leftMargin: visual.margins
                verticalCenter: dislikesLabel.verticalCenter
            }
        }
    }

    Item {
        anchors.right: parent.right
        anchors.rightMargin: visual.margins
        width: childrenRect.width

        InfoTextLabel {
            id: viewCountLabel
            text: videoInformationView.__prependToLength(videoInformationView.viewCount, 4, 0)
        }
        Image {
            source: visual.images.viewsIcon
            anchors {
                left: viewCountLabel.right
                leftMargin: visual.margins
                verticalCenter: viewCountLabel.verticalCenter
            }
        }
    }

    InfoTextLabel {
        id: titleLabel

        anchors {
            top: likes.bottom
            left: parent.left
            right: parent.right
            margins: visual.margins
        }
        width: parent.width
        maximumLineCount: 5
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        text: videoPlayView.videoTitle
        font.bold: true
    }
}

