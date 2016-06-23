/*
 * Settings.hpp
 *
 *  Created on: Jun 16, 2016
 *      Author: adonai
 */

#ifndef SETTINGS_HPP_
#define SETTINGS_HPP_

#include <QObject>
#include <QString>
#include <stdio.h>
#include <stdint.h>

class Settings: public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString location READ location WRITE setNewLocation NOTIFY downloadLocationChanged )
    Q_PROPERTY( int max_download READ maxDownload WRITE setMaxDownload NOTIFY maxDownloadChanged )
    Q_PROPERTY( int max_thread READ maxThread WRITE setMaxThread NOTIFY maxThreadChanged )
    Q_PROPERTY( int app_notify READ appNotification WRITE setAppNotification NOTIFY appNotificationChanged )
    Q_PROPERTY( int pause_on_error READ pauseOnError WRITE setPauseOnError NOTIFY pauseOnErrorChanged )
public:

private:
    int     download_directory_len;
    char    *download_directory;
    int     max_download;
    int     max_thread;
    int     app_notify;
    int     pause_on_error;
    FILE    *file;

    void writeSettings();
    void readSettings();
public:
    Settings( QObject *parent = NULL );
    virtual ~Settings();

    int maxThread() const { return max_thread; }
    int maxDownload() const { return max_download; }
    int appNotification() const { return app_notify; }
    int pauseOnError() const { return pause_on_error; }
    QString location() const { return QString( download_directory ); }

    void setNewLocation( QString loc );
    void setMaxDownload( int m );
    void setMaxThread( int t );
    void setAppNotification( int m );
    void setPauseOnError( int e );

signals:
    void error( QString message );
    void maxDownloadChanged( int );
    void maxThreadChanged( int );
    void appNotificationChanged( int );
    void pauseOnErrorChanged( int );
    void downloadLocationChanged( QString );
};

#endif /* SETTINGS_HPP_ */