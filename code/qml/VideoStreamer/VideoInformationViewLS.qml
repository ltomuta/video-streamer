import QtQuick 1.1
import com.nokia.meego 1.0
import "util.js" as Util

// Video information (views, likes & dislikes amounts) in landscape.
//
// Implementation duplicated from videoInformationViewLS, as fiddling
// around with anchors (for differentiating orientation modes) would've
// made the code almost un-readable.
Item {
    id: videoInformationViewLS

    property int numLikes: 0
    property int numDislikes: 0
    property int viewCount: 0

    // Prepends forward zeros to a text (e.g. 41 -> 0041)
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
        id: views

        anchors {
            right: parent.right
            rightMargin: visual.margins
            top: parent.top
            topMargin: visual.margins*5
        }
        height: childrenRect.height

        InfoTextLabel {
            id: viewCountLabel
            text: videoInformationViewLS.__prependToLength(videoInformationViewLS.viewCount, 4, 0)
                  + qsTr(" views")
            anchors.right: parent.right
        }
    }

    InfoTextLabel {
        id: likesLabel

        anchors {
            top: views.bottom
            topMargin: visual.margins*2
            right: parent.right
            rightMargin: visual.margins
        }

        // The forward zeros aren't prepended at the time being.
        //text: videoInformationViewLS.__prependToLength(videoInformationViewLS.numLikes, 4, 0)
        text: videoInformationViewLS.numLikes + qsTr(" likes")
    }

    InfoTextLabel {
        id: dislikesLabel
        anchors {
            top: likesLabel.bottom
            topMargin: visual.margins*2
            right: parent.right
            rightMargin: visual.margins
        }

        // The forward zeros aren't prepended at the time being.
        //text: videoInformationViewLS.__prependToLength(videoInformationViewLS.numDislikes, 4, 0)
        text: videoInformationViewLS.numDislikes + qsTr(" dislikes")
    }

    // Likes & dislikes images (thumbs up & thumbs down) currently disabled.
    // Textual information is being used instead.
//    Item {
//
//        anchors {
//            right: parent.right
//            rightMargin: visual.margins
//            top: views.bottom
//            topMargin: visual.margins*2
//        }
//
//        InfoTextLabel {
//            id: likesLabel
//
//            anchors.right: dislikesImg.left
//            // The forward zeros aren't prepended at the time being.
//            //text: videoInformationViewLS.__prependToLength(videoInformationViewLS.numLikes, 4, 0)
//            text: videoInformationViewLS.numLikes
//        }
//
//        Image {
//            id: likesImg
//
//            source: visual.images.thumbsUpIcon
//            anchors {
//                verticalCenter: likesLabel.verticalCenter
//                right: parent.right
//                rightMargin: visual.margins
//            }
//        }
//
//        InfoTextLabel {
//            id: dislikesLabel
//            anchors {
//                top: likesLabel.bottom
//                topMargin: visual.margins*2
//                right: dislikesImg.left
//            }
//
//            // The forward zeros aren't prepended at the time being.
//            //text: videoInformationViewLS.__prependToLength(videoInformationViewLS.numDislikes, 4, 0)
//            text: videoInformationViewLS.numDislikes
//        }
//
//        Image {
//            id: dislikesImg
//
//            source: visual.images.thumbsDownIcon
//            anchors {
//                right: parent.right
//                rightMargin: visual.margins
//                verticalCenter: dislikesLabel.verticalCenter
//            }
//        }
//    }
}
