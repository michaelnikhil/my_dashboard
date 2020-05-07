import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import "."
import QtCharts 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3

Window {
    visible: true
    title: qsTr("covid19 dashboard")
    SystemPalette {id:palette}
    property int margin: 11
//    width: mainLayout.implicitWidth + 2 * margin
//    height: mainLayout.implicitHeight + 2 * margin
//    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
//    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin
    width: 700
    height:600


    property var dates_qml: []
    property var values: []
    property string my_url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"


    RowLayout{
        id:mainLayout
        anchors.fill: parent
        anchors.margins: margin
        spacing: 6

        Rectangle {
            id:propertyBox
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 120
            Layout.preferredHeight: 400
            //anchors {
            //    left: parent.left
            //}
            ColumnLayout{
                id:buttonLayout
                anchors.fill: parent
                anchors.margins: margin
                Button{
                    id:button1
                    width: parent.width
                    text:"Plot file"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: fileDialog.open()
                }
                Button{
                    id:button2
                    width: parent.width
                    text:"Download"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: downloadmanager.doDownload(my_url)
                }
                Button{
                    id:button3
                    width: parent.width
                    text:"Plot"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:addSeries()
                }
            }
        }

        Rectangle {
            id:listBox
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 100
            Layout.preferredHeight: 400
            //anchors.fill: parent


             ListView {
                    width:100
                    height:80
                    id: countryListView
                    model: ModelCountries {}
                    //model:countrylist
                    delegate: DelegateCountry {}
                    focus: true
                }
        }
        Rectangle {
            id:displayBox
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 500
            Layout.preferredHeight: 400

            ChartView {
                id:mainChart
                title: "line"
                anchors.fill: parent
                antialiasing: true
                theme: ChartView.ChartThemeDark

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
            }
        }
    }


    FileDialog {
        id:fileDialog
        title:"Please choose file"
        folder:shortcuts.home
        onAccepted:
            {
            console.log("file name : " + fileDialog.fileUrls)
            var filesource = fileDialog.fileUrls
            fileio.setSource(filesource.toString())
            fileio.getDates()
            fileio.getCountries()
            fileio.getDataCountries("Sweden")
        }
        onRejected: {
            console.log("Cancelled")
            Qt.quit()
        }
    }

    MessageDialog {
        id:messageDialog
        title:"warning"
        icon: StandardIcon.Warning
    }

    Connections{
        id:checkDataAndPlot
        target: fileio
        onDatesLoaded: {
            console.log("*** dates loaded ***")
            //addSeries()
        }
    }

    function addSeries()
    {
        // Create new LineSeries
        var mySeries = mainChart.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
        fileio.setLineSeries(mySeries)
        console.log("series added")
    }

}


