/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import com.nokia.symbian 1.1
import QtQuick 1.1
import "storage.js" as Storage

Page {
    id: settingsView

    property variant pageStack
    property string viewName: "settingsView"

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
        id: tacCheckBoxItem

        anchors {
            top: playerSelection.bottom
            left: parent.left
            right: parent.right
        }
        height: playerSelection.height
        onClicked: checkBox.checked = !checkBox.checked

        CheckBox {
            id: checkBox

            anchors {
                verticalCenter: parent.paddingItem.verticalCenter
                left: parent.paddingItem.left
                right: parent.paddingItem.right
            }

            text: qsTr("Accept gathering user statistics")
            checked: visual.analyticsAccepted
            // Save the checked status persistently.
            onCheckedChanged: {
                Storage.setSetting("analyticsAccepted", checked);
                visual.analyticsAccepted = checked;
            }
        }
    }

    ListItem {
        anchors {
            top: tacCheckBoxItem.bottom
            left: parent.left
            right: parent.right
        }
        height: playerSelection.height
        onClicked: {
            queryLoader.sourceComponent = analyticsQuery;
            queryLoader.item.open();
        }

        Text {
            id: tncText

            anchors {
                top: parent.paddingItem.top
                horizontalCenter: parent.paddingItem.horizontalCenter
            }

            text: qsTr("In-App Analytics Terms And Conditions")
            color: platformStyle.colorNormalLight
        }

        Text {
            id: privacyPolicy

            anchors {
                top: tncText.bottom
                topMargin: 5
                horizontalCenter: parent.paddingItem.horizontalCenter
            }
            text: qsTr("<a href=\"http://www.nokia.com/global/privacy/privacy/policy/privacy-policy/\">Nokia Privacy Policy</a>")
            color: platformStyle.colorNormalLight
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link);
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
