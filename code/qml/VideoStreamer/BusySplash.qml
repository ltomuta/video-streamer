import QtQuick 1.1
import com.nokia.symbian 1.1

Item {

    // Signalled, when opacity reaches 0.
    signal dismissed

    Splash {
        id: splash
        portrait: visual.inPortrait
    }

    BusyIndicator {
        anchors.centerIn: splash
        width: visual.busyIndicatorWidth
        height: visual.busyIndicatorHeight
        running: true
    }

    Behavior on opacity {
        SequentialAnimation {
            NumberAnimation { duration: visual.animationDurationLong }
            ScriptAction { script: dismissed() }
        }
    }
}
