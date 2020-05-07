import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import "."
import QtCharts 2.0
import QtQuick.Dialogs 1.1



ChartView {
    id:mainChart
    antialiasing: true
    theme: ChartView.ChartThemeDark
    anchors.fill: parent

    DateTimeAxis {
        id:xTime
        format: "dd MM yyyy"
        tickCount: 5
        min: new Date(2020,1,20)
        max: new Date(2020,3,20)
    }

    ValueAxis {
        id:yValues
        min:0
        max:200
    }
    function addSeries()
    {
        // Create new LineSeries with 3 Axes (Two-Y-Axis, One-X-Axis)
        var mySeries = Chartview.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
        fileio.setLineSeries(mySeries)
    }

}





