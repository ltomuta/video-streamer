# Copyright (c) 2012 Nokia Corporation.

# Basic Qt configuration
QT += declarative
CONFIG += qt qt-components mobility
MOBILITY += multimedia

# Version number & version string definition (for using it inside the app)
VERSION = 1.1.0
VERSTR = '\\"$${VERSION}\\"'
DEFINES += VER=\"$${VERSTR}\"

# Add more folders to ship with the application, here
qml_sources.source = qml/VideoStreamer
qml_sources.target = qml
DEPLOYMENTFOLDERS = qml_sources

SOURCES += main.cpp loadhelper.cpp \
    playerlauncher.cpp
HEADERS += loadhelper.h \
    playerlauncher.h

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

# Platform specific files and configuration
symbian {
    # Allow network access on Symbian
    TARGET.CAPABILITY += NetworkServices
    TARGET.UID3 = 0xE0546EDD
    SOURCES += volumekeys.cpp
    HEADERS += volumekeys.h
    LIBS += -lremconcoreapi -lremconinterfacebase
}
contains(MEEGO_EDITION,harmattan) {
    icon_file.files = VideoStreamer.svg
    icon_file.path = /usr/share/icons/hicolor/scalable/apps
    INSTALLS += icon_file
    DEFINES += Q_WS_HARMATTAN
}

############################### ANALYTICS ####################################
# Uncomment to add the In App Analytics library by defining the IAA.
#DEFINES += IAA
contains(DEFINES, IAA) {
    warning("IAA Defined!")
    CONFIG += analytics

    symbian {
        # Capabilities needed by the Analytics library
        TARGET.CAPABILITY = LocalServices ReadUserData WriteUserData \
                            UserEnvironment ReadDeviceData
        # Define In-App Analytics dependency (for the Smart Installer to work)
        analytics_deploy.pkg_prerules = "(0x20031574), 3, 0, 8, {\"In-App Analytics\"}"
        DEPLOYMENT += analytics_deploy
    }
    # The In-App Analytics is wrapped into a VideoAnalytics QML "class".
    analytics_sources.source = qml/VideoAnalytics/IAA/VideoStreamer
    analytics_sources.target = qml
} else {
    warning("No IAA defined. Using console logging stub.")
    # If the IAA define is missing, use the VideoAnalytics stub implementation.
    analytics_sources.source = qml/VideoAnalytics/Console/VideoStreamer
    analytics_sources.target = qml
}
DEPLOYMENTFOLDERS += analytics_sources
############################### ANALYTICS ####################################

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
