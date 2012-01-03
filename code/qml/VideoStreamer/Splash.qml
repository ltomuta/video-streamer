import QtQuick 1.0

Item {
    id: splash

    property bool landscape: width > height

    anchors.fill: parent
    Image {
        id: bgImg
        anchors.fill: parent
        source: landscape ? "gfx/FilmReel_landscape.png" : "gfx/FilmReel.png"
    }
}
