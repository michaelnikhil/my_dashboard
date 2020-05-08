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

    property string my_url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

    //load data from c++ on startup
    Component.onCompleted: downloadmanager.doDownload(my_url)

    Connections{
        target: downloadmanager
        onFileDownloaded: {
            console.log("*** file downloaded ***")
            messageBox.append(Qt.formatTime(new Date(), "hh:mm") + " file downloaded")
            fileio.setSource("file:///home/michael/Qt/build-covid19_dashboard-Desktop-Profile/time_series_covid19_deaths_global.csv")
            //fileio.setSource(filesource.toString())
            fileio.getDates()
            fileio.getCountries()
            fileio.getDataCountries("Sweden")
        }
    }

    Connections{
        target: fileio
        onDatesLoaded: {
            console.log("*** dates loaded ***")
            messageBox.append(Qt.formatTime(new Date(), "hh:mm") +" dates loaded")
            addSeries()
        }
    }

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
                    onClicked: {
                        fileDialog.open()
                        messageBox.append(("*** another line ***"))
                    }
                }
                Button{
                    id:button2
                    width: parent.width
                    text:"Download"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: downloadmanager.doDownload(my_url)
                }
               /* Button{
                    id:button3
                    width: parent.width
                    text:"Plot"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:addSeries()
                }*/
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
                anchors.fill: parent
                antialiasing: true
                theme: ChartView.ChartThemeDark

                DateTimeAxis {
                    id:xTime
                    format: "dd MM yyyy"
                    tickCount: 5
                    min: new Date(2020,1,20)
                    max: new Date(2020,4,20)
                }

                ValueAxis {
                    id:yValues
                    min:0
                    max:400
                }

               /* LineSeries {
                    id:lineSeries1
                    axisX: xTime
                    axisY:yValues
                }*/
            }

   /*         Connections{
               target: fileio
                onDatesLoaded: {
                    console.log("*** dates loaded ***")
                    addSeries()
                 //     mainChart.removeAllSeries()
                 //   mainChart.title = "my title"
                 //   var mySeries = mainChart.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
                 //   fileio.setLineSeries(mySeries)
                }
            }*/
        }


        RowLayout{
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: margin
            spacing: 6

            Rectangle {
                anchors.fill: flickable
            }

            Flickable {
                id:flickable

                TextArea {
                    id:messageBox
                    width:200
                    height:40
                    //contentWidth: width
                    //contentHeight: TextArea.implicitHeight
                    readOnly: true
                    //wrapMode: Text.WordWrap
                    //text: "my_Test"
                    background: Rectangle {
                        color: "#FFFFFF"
                        border.width: 1
                        border.color: Control.activeFocus ? "5CAA15" : "#BDBEBF"
                    }
                }
                ScrollBar.vertical: ScrollBar {}
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
//            fileio.setSource("file:///home/michael/Qt/build-covid19_dashboard-Desktop-Profile/time_series_covid19_deaths_global.csv.0")
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


    function addSeries()
    {
        // Create new LineSeries
        mainChart.removeAllSeries()
        var mySeries = mainChart.createSeries(ChartView.SeriesTypeLine, "Line", xTime, yValues);
        fileio.setLineSeries(mySeries)
        console.log("series added")
    }

}


