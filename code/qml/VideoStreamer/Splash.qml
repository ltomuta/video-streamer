import QtQuick 1.0

Item {
    id: splash

    property bool landscape: width > height

    Image {
        id: bgImg
        anchors.fill: parent
        source: landscape ? "gfx/FilmReel_landscape.png" : "gfx/FilmReel.png"
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    Component.onDestruction: {
        splash.opacity = 0;
    }
}
