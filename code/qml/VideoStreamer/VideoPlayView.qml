import QtQuick 1.0
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1

Page {
    id: videoPlayView

    orientationLock: PageOrientation.LockLandscape

    function playVideo(videoUrl) {
        videoPlayer.stop()
        __enterFullScreen()
        videoPlayer.source = videoUrl
        videoPlayer.play()
    }

    function __enterFullScreen() {
        titleBar.height = 0
        titleBar.visible = false
        root.showToolBar = false
        root.showStatusBar = false
    }

    function __exitFullScreen() {
        titleBar.height = visual.titleBarHeight
        titleBar.visible = true
        root.showToolBar = true
        root.showStatusBar = true
    }

    function __toggleFullScreen() {
        if (titleBar.visible) {
            __enterFullScreen()
        } else {
            __exitFullScreen()
        }
    }

    property string videoPlayView: ""

    anchors.fill: parent


    tools: ToolBarLayout {
        id: toolBarLayout
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: {
                //root.showToolBar = true
                videoPlayer.stop()
                __exitFullScreen()
                root.pageStack.depth <= 1 ? Qt.quit() : root.pageStack.pop()
            }
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-menu"
            onClicked: {
                mainMenu.open();
            }
        }
    }


    TitleBar {
        id: titleBar

        height: visual.titleBarHeight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        visible: true
    }

    Rectangle {
        id: waitView

        anchors {
            //top: titleBar.bottom
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        color: "black"
        z: 1

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: qsTr("Buffering...")
        }
    }


   // Rectangle {
   //     anchors.fill: parent
   //     color: "black"

        Video {
            id: videoPlayer

            volume: 0.5
            autoLoad: true
            anchors {
                top: titleBar.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            fillMode: Video.PreserveAspectFit
            focus: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                        __toggleFullScreen()
                }
            }
        }
    //}

    states: State {
        name: "BufferingDone"
        when: (videoPlayer.status == Video.Buffered)

        PropertyChanges {
            target: waitView;
            opacity: 0
        }
    }
}

