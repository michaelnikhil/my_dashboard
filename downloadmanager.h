#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QStringList>
#include <QTimer>
#include <QUrl>

#include <stdio.h>

class DownloadManager: public QObject
{
    Q_OBJECT
    QNetworkAccessManager manager;
    QList<QNetworkReply *> currentDownloads;

public:
    DownloadManager();
    Q_INVOKABLE void doDownload(const QUrl &url);
    Q_INVOKABLE QString saveFileName(const QUrl &url);
    Q_INVOKABLE bool saveToDisk(const QString &filename, QIODevice *data);

public slots:
    void execute();
    void downloadFinished(QNetworkReply *reply);
};

#endif // DOWNLOADMANAGER_H
