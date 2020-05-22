#ifndef FILEIO_H
#define FILEIO_H

#include <QtCore>
#include<QChartView>
#include<QDateTimeAxis>
#include<QCategoryAxis>
#include <QtCharts/QLineSeries>
#include<QtCharts/QBarSeries>
#include<QtCharts/QBarCategoryAxis>
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
    Q_PROPERTY(QStringList countries_ordered READ get_countries_ordered NOTIFY countries_orderedLoaded  )
    Q_PROPERTY(QVector<int> dataCountriesPresent_ordered READ get_dataCountriesPresent_ordered NOTIFY dataCountriesPresent_orderedLoaded  )
    Q_PROPERTY(double yMax READ get_yMax NOTIFY yMaxChanged)
    Q_PROPERTY(int bMax READ get_bMax NOTIFY bMaxChanged)
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
    QStringList m_countries_ordered;
    QVector<int> m_dataCountriesPresent_ordered;
    QList<QObject*> m_countries2;
    double get_yMax() const {return m_yMax;}
    int get_bMax() const {return m_bMax;}
    QDateTime get_dMax() const {return m_dMax;}
    QDateTime m_dMax = QDateTime::fromString("2020/1/1", "yyyy/M/d");
    QVector<int> sortArr(QVector<int> arr, int n);
    QStringList get_countries_ordered() const {return m_countries_ordered;};
    QVector<int> get_dataCountriesPresent_ordered() const {return m_dataCountriesPresent_ordered;};

    public slots:
    void setSource(QUrl source);
    void getDates();
    void getDataCountries(QString aCountry);    // read rows
    void getDataCountriesPresent(); //read last column = present day
    void setLineSeries(QLineSeries* lineSeries);
    void setBarSeries(QBarSeries *barSeries);
    void setText(QString text);

signals:
    void sourceChanged(QUrl arg);
    void textChanged(QString arg);
    void error(QString arg);
    void datesLoaded();
    void countriesLoaded();
    void countries_orderedLoaded();
    void dataCountriesPresent_orderedLoaded();
    void yMaxChanged();
    void bMaxChanged();
    void dMaxChanged();

private:

    QUrl m_source;
    QString m_text;
    QVector<QDateTime> m_dates;
    QVector<double> m_dataCountry;
    QVector<int> m_dataCountriesPresent;
    double m_yMax=0;
    int m_bMax=0;
};

#endif // FILEIO_H


