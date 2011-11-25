import QtQuick 1.0
import com.nokia.symbian 1.1
import "util.js" as Util



Item {
    id: videoInformationView

    property string videoTitle: ""
    property int videoLength: 0
    property string videoAuthor: ""
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

    Column {
        Label {
            id: titleLabel

            text: videoInformationView.videoTitle
            font.bold: true
        }

        Row {
            spacing: visual.informationFieldHorizontalSpacing
            Label {
                id: lengthLabel
                text: Util.milliSecondsToString(videoInformationView.videoLength * 1000)
            }

            Label {
                id: authorLabel

                text: videoInformationView.videoAuthor
            }
        }

        Row {
            spacing: visual.informationFieldHorizontalSpacing

            Label {
                id: likesLabel

                text: videoInformationView.__prependToLength(videoInformationView.numLikes, 4, 0) + " " + ":)"

            }

            Label {
                id: dislikesLabel

                text: videoInformationView.__prependToLength(videoInformationView.numDislikes, 4, 0) + " " + ":("
            }
        }

        Label {
            id: viewCountLabel

            text: "<o>" + " " + videoInformationView.__prependToLength(videoInformationView.viewCount, 4, 0)
        }
    }
}
