#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"
#include "volumekeys.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    //viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    // Facebook authorization engine.
    VolumeKeys* volumeKeys = new VolumeKeys(0);
    viewer->rootContext()->setContextProperty("volumeKeys", volumeKeys);

    viewer->setMainQmlFile(QLatin1String("qml/VideoStreamer/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
