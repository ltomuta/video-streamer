/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QtCore/QString>
#include <QtCore/QTimer>
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeContext>
#include "qmlapplicationviewer.h"
#include "loadhelper.h"

#if defined(Q_OS_SYMBIAN)
#include "volumekeys.h"
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    //viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

#if defined(Q_OS_SYMBIAN)
    // Context property for listening the HW Volume key events in QML
    VolumeKeys* volumeKeys = new VolumeKeys(0);
    viewer->rootContext()->setContextProperty("volumeKeys", volumeKeys);

    // Set this attribute in order to avoid drawing the system
    // background unnecessarily.
    viewer->setAttribute(Qt::WA_NoSystemBackground);

    // Workaround for an issue with Symbian: "X.Y.Z" -> X.Y.Z
    static const QString VERSION_NUMBER(QString("%1").arg(VER).mid(1, QString(VER).length()-2));
#else
    static const QString VERSION_NUMBER(QString("%1").arg(VER)); // X.Y.Z by itself
#endif

    app->setApplicationVersion(VERSION_NUMBER);
    viewer->rootContext()->setContextProperty(QString("cp_versionNumber"), VERSION_NUMBER);

    viewer->setMainQmlFile(QLatin1String("qml/VideoStreamer/Splash.qml"));
    // Then trigger loading the *real* main.qml file, which can take longer to load.
    QScopedPointer<LoadHelper> loadHelper(
                LoadHelper::create(static_cast<QmlApplicationViewer*>(viewer.data())));
    QTimer::singleShot(1, loadHelper.data(), SLOT(loadMainQML()));

    viewer->showExpanded();

    return app->exec();
}
