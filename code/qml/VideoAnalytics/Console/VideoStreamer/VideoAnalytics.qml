import QtQuick 1.1

QtObject {
    id: videoAnalytics

    property int connectionTypePreference
    property int minBundleSize
    property int loggingEnabled

    function initialize(appKey, appVersion) {
        if (loggingEnabled)
            console.log("VideoAnalytics::initialize(" + appKey + ", " + appVersion + ")" );
    }

    function start(screen) {
        if (loggingEnabled)
            console.log("VideoAnalytics::start(" + screen + ")");
    }

    function stop(screen, isAppExit) {
        if (loggingEnabled)
            console.log("VideoAnalytics::stop(" + screen + ", isAppExit: " + isAppExit + ")" );
    }

    function logEvent(screen, eventName) {
        if (loggingEnabled)
            console.log("VideoAnalytics::logEvent(" +
                    screen + ", " +
                    eventName + ")");
    }

    Component.onCompleted: {
        console.log("connectionTypePreference: " + connectionTypePreference +
                    "\nminBundleSize: " + minBundleSize +
                    "\nloggingEnabled: " + loggingEnabled)
    }
}
