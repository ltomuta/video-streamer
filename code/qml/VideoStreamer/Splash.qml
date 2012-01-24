import QtQuick 1.1

Item {
    id: splash

    property bool portrait: height > width

    anchors.fill: parent
    Image {
        id: bgImg
        anchors.fill: parent
        source: "gfx/FilmReel_N9.png"
    }
}
