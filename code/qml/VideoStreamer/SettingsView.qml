/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import Analytics 1.0
import com.nokia.symbian 1.1
import QtQuick 1.1
import "storage.js" as Storage

Page {
    id: settingsView

    property variant pageStack
    property string viewName: "settingsView"

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            // Analytics: start gathering analytics events for the SettingsView.
            analytics.start(settingsView.viewName);
        } else if (status === PageStatus.Deactivating) {
            // Analytics: Stop measuring & logging events for SettingsView.
            analytics.stop(settingsView.viewName, Analytics.EndSession);
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: settingsView.pageStack.pop()
        }
    }

    TitleBar {
        id: logo

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    // Label for the settings view.
    InfoTextLabel {
        id: titleText

        anchors {
            top: logo.bottom
            topMargin: visual.margins*3
            left: parent.left
            leftMargin: visual.margins
        }
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: visual.largeFontSize
        font.bold: true
        text: qsTr("Settings")
    }

    SelectionListItem {
        id: playerSelection

        anchors.top: titleText.bottom
        title: qsTr("Used Video Player")
        subTitle: selectionDialog.selectedIndex >= 0
                  ? selectionDialog.model.get(selectionDialog.selectedIndex).name
                  : qsTr("Please select")

        onClicked: selectionDialog.open()

        SelectionDialog {
            id: selectionDialog

            titleText: qsTr("Select one of the values")
            selectedIndex: visual.usePlatformPlayer === false ? 0 : 1
            model: ListModel {
                ListElement { name: "QML Video Player" }        // model index 0
                ListElement { name: "Platform Video Player" }   // model index 1
            }

            // Save the selected player persistently. The Platform Video
            // Player is in the model index 1.
            onSelectedIndexChanged: {
                Storage.setSetting("usePlatformPlayer", selectedIndex === 1);
                visual.usePlatformPlayer = (selectedIndex === 1);
            }
        }
    }

    ListItem {
        anchors {
            top: playerSelection.bottom
            left: parent.left
            right: parent.right
        }
        height: checkBox.height + tncText.height + platformStyle.paddingLarge*2.5
        onClicked: checkBox.checked = !checkBox.checked

        CheckBox {
            id: checkBox

            anchors {
                top: parent.paddingItem.top
                left: parent.paddingItem.left
                right: parent.paddingItem.right
            }

            text: "Accept gathering user statistics"
            checked: visual.analyticsAccepted
            // Save the checked status persistently.
            onCheckedChanged: {
                Storage.setSetting("analyticsAccepted", checked);
                visual.analyticsAccepted = checked;
            }
        }

        Text {
            id: tncText

            anchors {
                top: checkBox.bottom
                left: checkBox.left
            }

            text: qsTr("<a href=\"query\">In-App Analytics Terms And Conditions</a>")
            color: platformStyle.colorNormalLight
            textFormat: Text.RichText
            onLinkActivated: {
                queryLoader.sourceComponent = analyticsQuery;
                queryLoader.item.open();
            }
        }
    }

    Loader {
        id: queryLoader
        anchors.centerIn: parent
    }

    Component {
        id: analyticsQuery

        AnalyticsQuery {
            onAccepted: checkBox.checked = true;
            onRejected: checkBox.checked = false;
        }
    }
}
