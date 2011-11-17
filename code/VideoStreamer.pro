#
# Basic Qt configuration
#
QT += declarative
CONFIG += qt-components
VERSION = 0.0.1
#CONFIG += qt-components mobility
#Speed up launching on MeeGo/Harmattan when using applauncherd daemon
#CONFIG += qdeclarative-boostable
#MOBILITY +=

# Add more folders to ship with the application, here
qml_sources.source = qml/VideoStreamer
qml_sources.target = qml
DEPLOYMENTFOLDERS = qml_sources

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

SOURCES += main.cpp

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
    TARGET.UID3 = 0xE0546EDD
    # Allow network access on Symbian
    symbian:TARGET.CAPABILITY += NetworkServices

    # Smart Installer package's UID
    # This UID is from the protected range and therefore the package will
    # fail to install if self-signed. By default qmake uses the unprotected
    # range value if unprotected UID is defined for the application and
    # 0x2002CCCF value if protected UID is given to the application
    #DEPLOYMENT.installer_header = 0x2002CCCF

   SOURCES += volumekeys.cpp
   HEADERS += volumekeys.h

   LIBS += -lremconcoreapi -lremconinterfacebase
}

contains(MEEGO_EDITION,harmattan) {
    #QT += opengl
    DEFINES += Q_WS_HARMATTAN
    icon_file.files = VideoStreamer.svg
    icon_file.path = /usr/share/icons/hicolor/scalable/apps
    INSTALLS += icon_file desktop
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
