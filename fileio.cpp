#include "fileio.h"
#include <QtCharts/QChartView>
#include<list>

FileIO::FileIO(QObject *parent)
    : QObject(parent)
{
}

FileIO::~FileIO()
{
}

void FileIO::read()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());
    if(!file.exists()) {
        qWarning() << "Does not exits: " << m_source.toLocalFile();
        m_text = "Does not exist";
        emit error(m_text);
        return;
    }
    if(file.open(QIODevice::ReadOnly)) {
        QString line;
        QTextStream t( &file );
        QString fileContent;
        do {
             line = t.readLine();
             fileContent += line;
             //QTextStream(stdout) << line <<  endl;
        } while (!line.isNull());
    }
}

void FileIO::readCSV()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QTextStream stream(&file);
    QStringList values;

    //get dates
    QString line = stream.readLine();
    values = line.split(",");
    QDateTime day;
    for (int i = 3; i < values.size(); i++) {
        day = QDateTime::fromString(values[i],"MM/dd/YY");
        m_dates.append(day);
        //QTextStream(stdout) << values[i] <<  " : " << day.toString() << endl;
    }

    int p =0;
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        if (line.startsWith("#") || line.startsWith(":"))
            continue;
        values = line.split(",");
        m_countries.append(values[0]);

/*        for (int i = 0; i < rowCount; i++) {
            QVector<qreal>* dataVec = new QVector<qreal>(rowCount);
            for (int k = 0; k < dataVec->size(); k++) {
                    if (k % 2 == 0)
                            dataVec->replace(k, i * 50 + QRandomGenerator::global()->bounded(20));
                        else
                            dataVec->replace(k, QRandomGenerator::global()->bounded(100));
                    }*/

/*
        QDateTime momentInTime;
        momentInTime.setDate(QDate(values[0].toInt(), values[1].toInt() , 15));
        m_data->append(momentInTime.toMSecsSinceEpoch(), values[2].toDouble());*/
    p++;
    }

    file.close();
}

void FileIO::getDates()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QTextStream stream(&file);
    QStringList values;
    QStringList string_dates;
    //get dates
    QString line = stream.readLine();
    values = line.split(",");
    QDateTime day_raw;
    QDateTime day;
    for (int i = 4; i < values.size(); i++) {
        day_raw = QDateTime::fromString(values[i],"M/d/yy");
        day = day_raw.addYears(100);
        m_dates.append(day);
        string_dates.append(day.toString());
    }
    if (string_dates.size() > 0) {
        m_dMax = day;
        emit datesLoaded();
        emit dMaxChanged();
    }
    file.close();


}

void FileIO::setLineSeries(QLineSeries *lineSeries)
{

    for (int i = 0; i < m_dataCountry.size(); i++) {
        lineSeries->append(m_dates[i].toMSecsSinceEpoch(),m_dataCountry[i]);
    }
}

void FileIO::getCountries()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QTextStream stream(&file);
    QStringList values;
    int p =0;
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        if (line.startsWith("#") || line.startsWith(":") ) {
            continue; }
        values = line.split(",");
        m_countries.append(values[1]);
        p++;
    }
    m_countries.removeDuplicates();
   /* for (int i = 0; i < m_countries.size(); ++i) {
        QTextStream(stdout) << m_countries[i] <<  endl;
    }*/
    if (m_countries.size() > 0) {
        emit countriesLoaded();
    }
    file.close();
}

void FileIO::getDataCountries(QString aCountry)
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QVector<double> dataCountry(m_dates.size());
    QTextStream stream(&file);
    QStringList values;
    int p =0;
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        if (line.startsWith("#") || line.startsWith(":")  ) {
            continue; }
        values = line.split(",");
        if (values[1] == aCountry) {
            for (int j = 4; j < values.size(); j++) {
                dataCountry[j-4] += values[j].toDouble();
                if (values[j].toDouble() > m_yMax) {
                    m_yMax = values[j].toDouble();
                    emit yMaxChanged();
                }
            }
        }
        p++;
    }

//    QTextStream(stdout) << aCountry << " number of data = " <<  dataCountry.size() << endl;
/*    for (int i = 0; i < m_dataCountry.size(); i++)
        QTextStream(stdout) << m_dataCountry[i] <<  endl;*/
    m_dataCountry = dataCountry;

    file.close();
}

void FileIO::write()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());
    if(file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);
        stream << m_text;
    }
}



QUrl FileIO::source() const
{
    return m_source;
}

QString FileIO::text() const
{
    return m_text;
}

void FileIO::setSource(QUrl source)
{
    if (m_source == source)
        return;
    m_source = source ;
    QTextStream(stdout) << "source print out : " << m_source.toLocalFile() <<  endl;
    emit sourceChanged(source);
}

void FileIO::setText(QString text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(text);
}




