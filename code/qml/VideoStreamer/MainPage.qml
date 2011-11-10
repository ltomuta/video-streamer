import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage

    // Background, shown everywhere
    Image {
        id: backgroundImg
        anchors.fill: parent
        source: "gfx/portrait_background.png"
    }

    ListModel {
        id: dummyListModel
        ListElement { title: "QML Shaders"; lengthInSecs: "460"; provider: "nokiadevforum" }
        ListElement { title: "Qt Quick Components 1.1"; lengthInSecs: "560"; provider: "nokiadevforum" }
        ListElement { title: "Qt 4.8"; lengthInSecs: "800"; provider: "nokiadevforum" }
        ListElement { title: "QML Performance Optimization tips"; lengthInSecs: "200"; provider: "nokiadevforum" }
        ListElement { title: "QML tips 'n tricks"; lengthInSecs: "360"; provider: "nokiadevforum" }
        ListElement { title: "OpenGL ES 2.0 with QML"; lengthInSecs: "750"; provider: "nokiadevforum" }
        ListElement { title: "Qt in Everyday Life"; lengthInSecs: "42"; provider: "nokiadevforum" }
        ListElement { title: "QML Rock n Roll around the clock"; lengthInSecs: "240"; provider: "nokiadevforum" }
    }

    ListView {
        id: listView
        clip: true
        anchors.fill: parent
        anchors.topMargin: visual.margins*2
        model: dummyListModel
        delegate: listDelegate
        focus: true
        spacing: visual.spacing
    }

    Component {
        id: listDelegate
        VideoListItem {
            width: listView.width
        }
    }
}
