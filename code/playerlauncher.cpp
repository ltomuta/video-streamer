#include "playerlauncher.h"

#include <QDebug>
#include <QDesktopServices>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QUrl>

PlayerLauncher::PlayerLauncher(QObject *parent) :
    QObject(parent)
{
}

void PlayerLauncher::launchPlayer(const QString &url)
{
    qDebug() << "Given url: " << url;
    qDebug() << "temp path:" << QDir::tempPath();
    QString videoFilePath = QDir::tempPath() + "/" + "videostreamer.ram";
    qDebug() << "videofilepath:" << videoFilePath;
    QFile file(videoFilePath);

    if(file.exists()) {
        file.remove();
    }

    if(file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        QTextStream out(&file);
        qDebug() << "Writing url to QTextStream!";
        out << url;
    }
    file.close();

    qDebug() << "File closed! Opening url:" << QUrl("file:///" + videoFilePath).toString();
    QDesktopServices::openUrl(QUrl("file:///" + videoFilePath));
}
