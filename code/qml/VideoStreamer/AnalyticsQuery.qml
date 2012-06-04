/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import com.nokia.symbian 1.1
import QtQuick 1.1

QueryDialog {
    titleText: qsTr("In-App Analytics Disclaimer")
    message: qsTr("To enable future improvements, application usage data is "
             + "being collected by this Nokia example application. "
             + "You can switch the analytics data collection on/off from "
             + "the settings at any time. The information is collected in accordance with "
             + "Nokia Privacy Policy.")
    acceptButtonText: qsTr("Accept")
    rejectButtonText: qsTr("Reject")
}
