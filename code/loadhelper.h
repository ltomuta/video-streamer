/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef LOADHELPER_H
#define LOADHELPER_H

#include <QObject>

// Forward declarations
class QmlApplicationViewer;

class LoadHelper : public QObject
{
    Q_OBJECT

public:
    static LoadHelper *create(QmlApplicationViewer *viewer, QObject *parent = 0);
    explicit LoadHelper(QmlApplicationViewer *viewer, QObject *parent = 0);

public slots:
    void loadMainQML();

private: // Data
    QmlApplicationViewer *m_viewer;     // Not owned
};

#endif // LOADHELPER_H
