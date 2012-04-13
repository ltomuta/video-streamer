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

    function stop(screen, closeReason) {
        analytics.stop(screen, closeReason);
    }

    function logEvent(screen, eventName, eventType) {
        analytics.logEvent(screen, eventName, eventType);
    }

    // Create Analytics QML-item and set values for all available optional properties.
    Analytics {
        id: analytics

        connectionTypePreference: videoAnalytics.connectionTypePreference
        minBundleSize: videoAnalytics.minBundleSize
        loggingEnabled: videoAnalytics.loggingEnabled
    }
}
