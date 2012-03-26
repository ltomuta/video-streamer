/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import com.nokia.symbian 1.1
import QtQuick 1.1

QueryDialog {
    titleText: qsTr("In-App Analytics Disclaimer")
    message: qsTr("The service includes a voluntary "
             + "service improvement program, which collects statistical "
             + "information about your use of the application. The information "
             + "is not used to identify you personally. You may control your "
             + "participation to the program from the settings of the "
             + "application. The information is collected in accordance with "
             + "Nokia Privacy Policy.")
    acceptButtonText: qsTr("Accept")
    rejectButtonText: qsTr("Reject")
}
