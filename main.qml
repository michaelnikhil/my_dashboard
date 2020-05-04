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
    width: mainLayout.implicitWidth + 2 * margin
    height: mainLayout.implicitHeight + 2 * margin
    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

    property var dates_qml: []
    property var values: []
    property string my_url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"


    RowLayout{
        id:mainLayout
        anchors.fill: parent
        anchors.margins: margin
        spacing: 6

        GroupBox {
            id:propertyBox
            title: "property box"
            implicitWidth: 120
            implicitHeight: 400
            anchors {
                left: parent.left
            }
            ColumnLayout{
                id:buttonLayout
                anchors.fill: parent
                anchors.margins: margin
                Button{
                    id:button1
                    width: parent.width
                    text:"Open"
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
                    onClicked: addSeries()
                }
            }
        }

        GroupBox {
            id:displayBox
            title: "display box"
            implicitWidth: 400
            implicitHeight: 400
            anchors {
                right: parent.right
            }
            ChartView {
                id:mainChart
                title: "line"
                anchors.fill: parent
                antialiasing: true
                theme: ChartView.ChartThemeDark

               /* ValueAxis {
                    id:xTime
                    min:0
                    max:4
                }*/
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

                /*
                CategoryAxis{
                    id:yDescription
                }
                CategoryAxis {
                    id:xTime
                }
                CategoryAxis {
                    id:yValues
                }
*/

/*                LineSeries {
                    name: "LineSeries"
                    XYPoint {x:0 ; y:0 }
                    XYPoint {x:1 ; y:1 }
                    XYPoint {x:2 ; y:4 }
                    XYPoint {x:3 ; y:9 }
                }*/
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
    // when new data is sent from C++, parse the JSON and use as chartData in QML
  /*  Connections {
      target: FileIO
      // the dataLoaded signal provides a jsonDataString parameter
      onDatesLoaded: dates_qml = dates_cpp
    }*/


    MessageDialog {
        id:messageDialog
        title:"warning"
        icon: StandardIcon.Warning
    }

    function addSeries()
    {
        // Create new LineSeries with 3 Axes (Two-Y-Axis, One-X-Axis)
        var mySeries = mainChart.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
        fileio.setLineSeries(mySeries)
    }
/*
    Rectangle{
        id:bottomBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height:buttonRow.height * 1.2
        color: Qt.darker(palette.window,1.5)
        border.color:Qt.darker(palette.windpw,1.5)

        Row{
            id:buttonRow
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            anchors.leftMargin: 12
            height: implicitHeight
            width: parent.width
            Button{
                id:button1
                text:"Open file"
                //ToolTip:"load a csv file"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialog.open()
            }
            Button{
                id:button2
                text:"Open file"
                //ToolTip:"load a csv file"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialog.open()
            }

        }*/

    }
/*    ListView {
        id: countryListView
        anchors.fill: parent
        model: ModelCountries {}
        delegate: DelegateCountry {}
        focus: true

    }

*/

