/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include <QtCore/QString>
#include <QtCore/QTimer>
#include <QtCore/QDir>
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeComponent>
#include <QtDeclarative/QDeclarativeEngine>

#include "qmlapplicationviewer.h"
#include "loadhelper.h"
#include "playerlauncher.h"

#if defined(Q_OS_SYMBIAN)
#include "volumekeys.h"
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());
    // Data model is created immediately to allow data fetching
    // during splash screen is shown.
    QScopedPointer<QDeclarativeComponent> dataModelComponent(
                new QDeclarativeComponent(
                    viewer->engine(),
                    QUrl::fromLocalFile("qml/VideoStreamer/VideoListModel.qml")) );
    QScopedPointer<QObject> dataModel(dataModelComponent->create());
    viewer->rootContext()->setContextProperty("xmlDataModel", dataModel.data());
    QScopedPointer<PlayerLauncher> playerLauncher(new PlayerLauncher);
    viewer->rootContext()->setContextProperty("playerLauncher", playerLauncher.data());

#if defined(Q_OS_SYMBIAN)
    // Context property for listening the HW Volume key events in QML
    QScopedPointer<VolumeKeys> volumeKeys(new VolumeKeys(0));
    viewer->rootContext()->setContextProperty("volumeKeys", volumeKeys.data());

    // Set this attribute in order to avoid drawing the system
    // background unnecessarily.
    viewer->setAttribute(Qt::WA_NoSystemBackground);

    // Workaround for an issue with Symbian: "X.Y.Z" -> X.Y.Z
    static const QString VERSION_NUMBER(QString("%1").arg(VER).mid(1, QString(VER).length()-2));
#else
    static const QString VERSION_NUMBER(QString("%1").arg(VER)); // X.Y.Z by itself
#endif

    // Set the application version number as a context property (for the AboutView
    // to show) and set the quick loading Splash QML file.
    app->setApplicationVersion(VERSION_NUMBER);
    viewer->rootContext()->setContextProperty(QString("cp_versionNumber"), VERSION_NUMBER);
    viewer->setMainQmlFile(QLatin1String("qml/VideoStreamer/Splash.qml"));
#if defined(IAA)
    viewer->rootContext()->setContextProperty(QString("cp_IAADefined"), true);
#else
    viewer->rootContext()->setContextProperty(QString("cp_IAADefined"), false);
#endif

    // Then trigger loading the *real* main.qml file, which can take longer to load.
    QScopedPointer<LoadHelper> loadHelper(
                LoadHelper::create(static_cast<QmlApplicationViewer*>(viewer.data())));
    QTimer::singleShot(1, loadHelper.data(), SLOT(loadMainQML()));

    // Show the QML app & execute the main loop.
    viewer->showExpanded();
    return app->exec();
}
