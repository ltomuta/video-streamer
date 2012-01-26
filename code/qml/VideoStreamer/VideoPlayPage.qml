import QtQuick 1.1
import com.nokia.meego 1.0
import "VideoPlayer"

Page {

    VideoPlayView {
        id: videoPlayView

        onVideoExit: {
            // VideoPlayView was dynamically created in VideoListItem and must
            // be destroyed. However just calling destroy without any delay will
            // block whole application if Video-element status is Video.Loading.
            // To prevent this give Video-element enough time to handle it's
            // state and delay destroy by 1 minute.
            videoPlayView.destroy(60000)
            pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
        }

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
