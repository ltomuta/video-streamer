/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import Analytics 1.0
import QtQuick 1.1
import com.nokia.symbian 1.1
import "VideoPlayer"

Page {
    id: videoPlayPage

    function setVideoData(videoData) {
        videoPlayView.setVideoData(videoData);
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            // Analytics: Start the session for the VideoPlayer screen.
            analytics.start("VideoPlayView");

            // Don't show the bg image behind the video play view.
            visual.showBackground = false;
        } else if (status === PageStatus.Deactivating) {
            // Analytics: Stop measuring & logging events for VideoPlayer.
            analytics.stop("VideoPlayView", Analytics.SessionCloseReason);

            // The background image can be shown once again.
            visual.showBackground = true;
        }
    }

    anchors.fill: parent

    VideoPlayView {
        id: videoPlayView

        onVideoExit: {
            // VideoPlayView was dynamically created in VideoListItem and must
            // be destroyed. However just calling destroy without any delay will
            // block whole application if Video-element status is Video.Loading.
            // To prevent this give Video-element enough time to handle it's
            // state and delay destroy by 1 minute.
            videoPlayPage.destroy(60000);
            pageStack.pop();
        }
    }
}
