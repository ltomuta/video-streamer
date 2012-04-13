import Analytics 1.0
import QtQuick 1.1

Item {
    id: videoAnalytics

    property int connectionTypePreference
    property int minBundleSize
    property int loggingEnabled

    function initialize(appKey, appVersion) {
        analytics.initialize(appKey, appVersion);
    }

    function start(screen) {
        analytics.start(screen);
    }

    function stop(screen, isAppExit) {
        analytics.stop(screen, isAppExit ? Analytics.AppExit
                                         : Analytics.EndSession);
    }

    function logEvent(screen, eventName) {
        analytics.logEvent(screen, eventName, Analytics.ActivityLogEvent);
    }

    // Create Analytics QML-item and set values for all available optional properties.
    Analytics {
        id: analytics

        connectionTypePreference: Analytics.AnyConnection
        minBundleSize: videoAnalytics.minBundleSize
        loggingEnabled: videoAnalytics.loggingEnabled
    }
}
