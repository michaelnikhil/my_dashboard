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
    property string my_country: "France"
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
        }
    }

    Connections{
        target: fileio
        onDatesLoaded: {
            console.log("*** dates loaded ***")
            messageBox.append(Qt.formatTime(new Date(), "hh:mm") +" dates loaded : click on plot")
            button3.visible=true
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
                        messageBox.append(Qt.formatTime(new Date(), "hh:mm") + " file loaded")

                    }
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
                    visible: false
                    highlighted: true
                    width: parent.width
                    text:"Plot"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:addSeries()
                }

                ComboBox {
                    id:combobox
                    implicitWidth: propertyBox.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    editable: true
                    model: fileio.countries
                    onAccepted: {
                        my_country = combobox.currentText
                        console.log(my_country)
                        messageBox.append(Qt.formatTime(new Date(), "hh:mm") + " country chosen: " + my_country)
                        fileio.getDataCountries(my_country)
                        console.log(xTime.max)
                        addSeries()
                    }
                }
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
                    max: new Date(2020,4,21)
                }

                ValueAxis {
                    id:yValues
                    min:0
                    max:400
                }
            }

        }
}

        Row {
            id:lowerRow
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: margin
            spacing: 6

            ScrollView {
                id:view
                TextArea {
                    id:messageBox
                    //width:200
                    //height:40
                    readOnly: true
                    //wrapMode: Text.WordWrap
                    background: Rectangle {
                        color: "#DDBEBF"
                        border.width: 1
                        border.color: Control.activeFocus ? "5CAA15" : "#BDBEBF"
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
//            fileio.setSource("file:///home/michael/Qt/build-covid19_dashboard-Desktop-Profile/time_series_covid19_deaths_global.csv.0")
            fileio.getDates()
            fileio.getCountries()
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
        //mainChart.removeAllSeries()

        var mySeries = mainChart.createSeries(ChartView.SeriesTypeLine, my_country, xTime, yValues);
        //mainChart.axisX(xTime)
        //mainChart.axisY(yValues)
        fileio.setLineSeries(mySeries)
        console.log("series added")
    }
    function removeSeries()
    {
        mainChart.removeAllSeries()
        mainChart.axisX(xTime)
        mainChart.axisY(yValues)

    }
}


