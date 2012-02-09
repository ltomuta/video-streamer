#ifndef PLAYERLAUNCHER_H
#define PLAYERLAUNCHER_H

#include <QObject>
#include <QString>

class PlayerLauncher : public QObject
{
    Q_OBJECT
public:
    explicit PlayerLauncher(QObject *parent = 0);
    
signals:
    
public slots:
    void launchPlayer(const QString &url);
    
};

#endif // PLAYERLAUNCHER_H
