# Copyright (c) 2012 Nokia Corporation.

# Basic Qt configuration
QT += declarative
CONFIG += qt qt-components mobility
MOBILITY += multimedia

# Version number & version string definition (for using it inside the app)
VERSION = 0.5.0
VERSTR = '\\"$${VERSION}\\"'
DEFINES += VER=\"$${VERSTR}\"

# Add more folders to ship with the application, here
qml_sources.source = qml/VideoStreamer
qml_sources.target = qml
DEPLOYMENTFOLDERS = qml_sources

SOURCES += main.cpp loadhelper.cpp
HEADERS += loadhelper.h

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
} else:harmattan {
    icon_file.files = VideoStreamer.svg
    icon_file.path = /usr/share/icons/hicolor/scalable/apps
    INSTALLS += icon_file
    DEFINES += Q_WS_HARMATTAN
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
