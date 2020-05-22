#include "fileio.h"
#include <QtCharts/QBarSet>
#include<QtCharts/QBarCategoryAxis>
#include<list>
using namespace std;

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

void FileIO::setBarSeries(QBarSeries *barSeries)
{
    for (int i = 0; i < 9; i++) {
        QBarSet *set = new QBarSet(m_countries_ordered[i]);
        *set << m_dataCountriesPresent_ordered[i];
        barSeries->append(set);
    }
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

    m_dataCountry = dataCountry;

    file.close();
}

void FileIO::getDataCountriesPresent()
{
    if(m_source.isEmpty()) {
        return;
    }
    QFile file(m_source.toLocalFile());

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QVector<int> dataCountriesPresent_tmp;
    QStringList countries;
    QTextStream stream(&file);
    QStringList values;
    QString  country;
    QString country_old = "";

    //1st loop, keep country duplicates
    int p =0;
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        if (line.startsWith("#") || line.startsWith(":")  ) {
            continue; }
        values = line.split(",");
        countries.append(values[1]);
        dataCountriesPresent_tmp.append(values.last().toDouble());
        p++;
    }
    m_countries = countries;

    //2nd loop, remove country duplicates and sum data
    m_countries.removeDuplicates();
    QVector<int> dataCountriesPresent(m_countries.size());

    for (int i=0; i<m_countries.size();i++) {
        for (int j=0; j<countries.size();j++) {
            if (countries[j] == m_countries[i])
                dataCountriesPresent[i] += dataCountriesPresent_tmp[j];
        }
//        QTextStream(stdout) << m_countries[i] << " values : " << dataCountriesPresent[i]
//                                        <<  endl;
    }

    m_dataCountriesPresent = dataCountriesPresent;
    if (m_countries.size() > 0) {
        emit countriesLoaded();
        }

    //sort list
    QVector<int> sortedIndex = sortArr(m_dataCountriesPresent,m_dataCountriesPresent.size());

    QStringList countries_ordered;
    QVector<int> dataCountriesPresent_ordered(m_countries.size());

    for (int i=0; i<m_countries.size();i++) {
        countries_ordered.append(m_countries[sortedIndex[i]]);
        dataCountriesPresent_ordered[i] = dataCountriesPresent[sortedIndex[i]];
    }
    m_countries_ordered=countries_ordered;
    m_dataCountriesPresent_ordered=dataCountriesPresent_ordered;

//    for (int i=0; i<m_countries.size();i++) {
//        QTextStream(stdout) << m_countries_ordered[i] << "  " << m_dataCountriesPresent_ordered[i]
//                                                <<  endl;
//    }
    m_bMax = m_dataCountriesPresent_ordered[0];

    if (m_countries_ordered.size() > 0) {
        emit countries_orderedLoaded();
        emit dataCountriesPresent_orderedLoaded();
        emit bMaxChanged();}
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

QVector<int> FileIO::sortArr(QVector<int> arr, int n)
{
    // reference
    //https://www.geeksforgeeks.org/keep-track-of-previous-indexes-after-sorting-a-vector-in-c-stl/
    QVector<int> sortedIndex(arr.size());
    // Vector to store element
    // with respective present index
    vector<pair<int, int> > vp;

    // Inserting element in pair vector
    // to keep track of previous indexes
    for (int i = 0; i < n; ++i) {
        vp.push_back(make_pair(arr[i], i));
    }

    // Sorting pair vector
    sort(vp.begin(), vp.end());

    for (int i = 0; i < vp.size(); i++) {
        sortedIndex[i] = vp[i].second;
    }
    std::reverse(std::begin(sortedIndex), std::end(sortedIndex));
    return sortedIndex;
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




