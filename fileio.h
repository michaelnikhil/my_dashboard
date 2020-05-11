#ifndef FILEIO_H
#define FILEIO_H

#include <QtCore>
#include<QChartView>
#include<QDateTimeAxis>
#include<QCategoryAxis>
#include <QtCharts/QLineSeries>
#include <QString>
#include<QDate>

QT_CHARTS_USE_NAMESPACE


class FileIO : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(FileIO)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QStringList countries MEMBER m_countries NOTIFY countriesLoaded  )
    Q_PROPERTY(double yMax READ get_yMax NOTIFY yMaxChanged)
    Q_PROPERTY(QDateTime dMax READ get_dMax NOTIFY dMaxChanged)
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
    double get_yMax() const {return m_yMax;}
    QDateTime get_dMax() const {return m_dMax;}

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
    void countriesLoaded();
    void yMaxChanged();
    void dMaxChanged();

private:

    QUrl m_source;
    QString m_text;
    QVector<QDateTime> m_dates;
    QVector<double> m_dataCountry;
    double m_yMax=0;
    QDateTime m_dMax = QDateTime::fromString("2020/1/1", "yyyy/M/d");
};

#endif // FILEIO_H


