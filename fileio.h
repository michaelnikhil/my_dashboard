#ifndef FILEIO_H
#define FILEIO_H

#include <QtCore>
#include<QChartView>
#include<QDateTimeAxis>
#include<QCategoryAxis>
#include <QtCharts/QLineSeries>
#include <QString>

QT_CHARTS_USE_NAMESPACE

//static QString DataDirName="EnRSim-Data";

class FileIO : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(FileIO)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
public:
    FileIO(QObject *parent = 0);
    ~FileIO();

    Q_INVOKABLE void read();
    Q_INVOKABLE void readCSV();
    Q_INVOKABLE void write();

    QUrl source() const;
    QString text() const;
    QStringList m_countries;
    QList<QObject*> m_countries2;

public slots:
    void setSource(QUrl source);
    void getDates();
    void getCountries(); //read 1st column
    void getDataCountries(QString aCountry);    // read rows
    void setLineSeries(QLineSeries* lineSeries);
    void setText(QString text);
signals:
    void sourceChanged(QUrl arg);
    void textChanged(QString arg);
    void error(QString arg);
    void datesLoaded();

private:

    QUrl m_source;
    QString m_text;
    QVector<QDateTime> m_dates;
    QVector<double> m_dataCountry;


//    QVariantList m_dataCountry;
};

#endif // FILEIO_H


