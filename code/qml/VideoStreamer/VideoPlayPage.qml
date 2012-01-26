import QtQuick 1.1
import com.nokia.symbian 1.1
import "VideoPlayer"

Page {

    VideoPlayView {
        id: videoPlayView
    }

    function setVideoData(videoData) {
        videoPlayView.setVideoData(videoData)
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            // Don't show the bg image behind the video play view.
            visual.showBackground = false;
        } else if (status === PageStatus.Deactivating) {
            // The background image can be shown once again.
            visual.showBackground = true;
        }
    }

    anchors.fill: parent
}
