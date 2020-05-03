#ifndef FILEIO_H
#define FILEIO_H

#include <QtCore>
#include<QChartView>
#include<QDateTimeAxis>
#include<QCategoryAxis>
#include <QtCharts/QLineSeries>

QT_CHARTS_USE_NAMESPACE

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
    Q_INVOKABLE void getCountries(); //read 1st column
    Q_INVOKABLE void getDataCountries(QString aCountry);    // read rows
    Q_INVOKABLE void write();
    Q_INVOKABLE void getDates(); //FIXME
    Q_INVOKABLE void setLineSeries(QLineSeries* lineSeries);

    QUrl source() const;
    QString text() const;
//    QList<QObject*> dataList {return m_countries2};
public slots:
    void setSource(QUrl source);
    void setText(QString text);
signals:
    void sourceChanged(QUrl arg);
    void textChanged(QString arg);
    void Error(QString arg);
    void DatesLoaded(const QStringList& dates_cpp);

private:
//    void getDates(); //read 1st row
    QUrl m_source;
    QString m_text;
    QStringList m_countries;
    QList<QObject*> m_countries2;
    QVector<QDateTime> m_dates;
    QVector<double> m_dataCountry;

//    QVariantList m_dataCountry;
};

#endif // FILEIO_H


