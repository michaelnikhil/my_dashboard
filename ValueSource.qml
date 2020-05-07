import QtQuick 2.0
import QtCharts 2.0

Item {
    id:valueSource
    function addSeries()
    {
        // Create new LineSeries with 3 Axes (Two-Y-Axis, One-X-Axis)
        var mySeries = Chartview.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
        fileio.setLineSeries(mySeries)
    }

}
