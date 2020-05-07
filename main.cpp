#include <QApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include<QtCharts/QChartView>
#include<QtCharts/QBarSeries>
#include<QtCharts/QBarSet>
#include<QtCharts/QLegend>
#include<QtCharts/QBarCategoryAxis>
#include<QtCharts/QHorizontalStackedBarSeries>
#include<QtCharts/QLineSeries>
#include<QtCharts/QCategoryAxis>
#include<QtCharts/QPieSeries>
#include<QtCharts/QPieSlice>

#include "fileio.h"
#include "downloadmanager.h"

QT_CHARTS_USE_NAMESPACE


int main(int argc, char *argv[])
{

//    QLocale::setDefault(QLocale(QLocale::English));
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);


    FileIO* fileio = new FileIO();
    DownloadManager* downloadmanager = new DownloadManager();

    QQmlApplicationEngine engine;
    QQmlContext * context = engine.rootContext();
    context->setContextProperty("fileio",fileio);
    context->setContextProperty("downloadmanager",downloadmanager);
    context->setContextProperty("countrylist",fileio->m_countries);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
