#include <QApplication>
#include <QQmlApplicationEngine>
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

    QLocale::setDefault(QLocale(QLocale::English));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
//    DownloadManager manager;
//    QTimer::singleShot(0, &manager, SLOT(execute()));

    qmlRegisterType<FileIO>("FileIO",1,0,"FileIO");
    qmlRegisterType<DownloadManager>("DownloadManager",1,0,"DownloadManager");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
