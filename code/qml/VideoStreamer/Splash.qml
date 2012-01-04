import QtQuick 1.1

Item {
    id: splash

    property bool portrait: screen.displayHeight > screen.displayWidth

    anchors.fill: parent
    Image {
        id: bgImg
        anchors.fill: parent
        source: portrait ? "gfx/FilmReel.png" : "gfx/FilmReel_landscape.png"
    }
}
