// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

Item {

    // Signalled, when opacity reaches 0.
    signal dismissed()

    Splash {
        id: splash
    }

    BusyIndicator {
        anchors.centerIn: splash
        width: visual.busyIndicatorWidth
        height: visual.busyIndicatorHeight
        running: true
    }

    Behavior on opacity {
        SequentialAnimation {
            NumberAnimation { duration: 600 }
            ScriptAction { script: dismissed() }
        }
    }

    Component.onDestruction: console.log("DESTROYED BUSYSPLASH!")
}
