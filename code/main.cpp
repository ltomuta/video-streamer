#include <QtGui/QApplication>
#include <QDeclarativeContext>
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
#endif

    viewer->setMainQmlFile(QLatin1String("qml/VideoStreamer/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
