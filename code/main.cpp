#include <QtCore/QString>
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeContext>
#include "qmlapplicationviewer.h"

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

    // Workaround for an issue with Symbian: "X.Y.Z" -> X.Y.Z
    static const QString VERSION_NUMBER(QString("%1").arg(VER).mid(1, QString(VER).length()-2));
#else
    static const QString VERSION_NUMBER(QString("%1").arg(VER)); // X.Y.Z by itself
#endif

    app->setApplicationVersion(VERSION_NUMBER);
    viewer->rootContext()->setContextProperty(QString("cp_versionNumber"), VERSION_NUMBER);
    viewer->setMainQmlFile(QLatin1String("qml/VideoStreamer/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
