import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import "."
import QtCharts 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

Window {
    visible: true
    id:mainView
    title: qsTr("covid19 dashboard")
    //Layout.fillWidth: true
    SystemPalette {id:palette}
    property int margin: 11

    width: mainLayout.implicitWidth + 2 * margin
    height: mainLayout.implicitHeight + 2 * margin
    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

    property string my_url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
    property string my_country: "France"
    //load data from c++ on startup
    Component.onCompleted: downloadmanager.doDownload(my_url)

    Connections{
        target: downloadmanager
        onFileDownloaded: {
            console.log("*** file downloaded ***")
            console.log("file:///" + appPath + "/" + downloadmanager.saveFileName(my_url))
            messageBox.append(Qt.formatTime(new Date(), "hh:mm") + " file downloaded")
            messageBox.append(Qt.formatTime(new Date(), "hh:mm") +  appPath)
            fileio.setSource("file://"+appPath + "/" + downloadmanager.saveFileName(my_url))
            fileio.getDates()
            fileio.getDataCountriesPresent()
            addBarSeries()
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


    GridLayout{
        id: mainLayout
        columns: 2
        flow: GridLayout.LeftToRight
        anchors.fill: parent
        anchors.margins: margin

        Rectangle {
            id:propertyBox
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 120
            Layout.preferredHeight: 400

            ColumnLayout{
                id:buttonLayout
                anchors.fill: parent
                spacing: 20
                Button{
                    id:button1
                    width: parent.width
                    text:"Load file"
                    onClicked: {
                        fileDialog.open()
                        messageBox.append(Qt.formatTime(new Date(), "hh:mm") + " file loaded")
                    }
                }
                Button{
                    id:button2
                    width: parent.width
                    text:"Reset plot"
                    onClicked: removeSeries()
                }
                Button{
                    id:button3
                    visible: false
                    highlighted: true
                    width: parent.width
                    text:"Plot"
                    onClicked:addSeries()
                }

                ComboBox {
                    id:combobox
                    implicitWidth: propertyBox.width
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
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 200
            Layout.preferredWidth: 300
            Layout.preferredHeight: 400
            ColumnLayout{
                spacing: 5
                anchors.fill: parent
                ChartView {
                    id:mainChart
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    antialiasing: true
                    theme: ChartView.ChartThemeDark

                    DateTimeAxis {
                        id:xTime
                        format: "dd MM yyyy"
                        tickCount: 5
                        min: new Date(2020,1,20)
                        max: fileio.dMax
                    }

                    ValueAxis {
                        id:yValues
                        min:0
                        max:fileio.yMax
                    }
                }

                Rectangle {
                    id:textCountries
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    border.width: 2

                    ChartView{
                        id: rankChart
//                        Layout.fillWidth: true
//                        Layout.fillHeight: true
//                        legend.alignment: Qt.AlignBottom
                        anchors.fill: parent
                        antialiasing: true
//                         Component.onCompleted: {
//                             addBarSeries()
//                         }

                        BarCategoryAxis{
                            id: xCountry
                        }
                        ValueAxis{
                            id: yValuesLast
                            min:0
                            max:80000
                        }


//                        BarSeries {
//                        id: myBarSeries
//                        axisX: xCountry
//                        axisY: yValuesLast
//                        BarSet {
//                            id: rainfallSet
//                            label: "Rainfall"
//                        }
//                    }
//                        BarSeries {
//                            id: mySeries
//                            axisX: BarCategoryAxis { categories: ["2007", "2008", "2009", "2010", "2011", "2012" ] }
//                            BarSet { label: "Bob"; values: [2, 2, 3, 4, 5, 6] }
//                            BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
//                            BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
//                        }
                    }

                }
            }
        }

        Rectangle {
            id:lowerRow
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.columnSpan: 2
            border.width: 2

            ScrollView {
                id:view
                clip: true
                TextArea {
                    id:messageBox
                    //width:200
                    //height:view.viewport.height
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                    readOnly: true
                    //wrapMode: Text.WrapAnywhere
//                    background: Rectangle {
//                        Layout.fillHeight: true
//                        Layout.fillWidth: true
//                        Layout.preferredHeight: 60
//                        Layout.columnSpan: 2
//                        //color: "#DDBEBF"
//                        border.width: 1
//                        border.color: Control.activeFocus ? "5CAA15" : "#BDBEBF"
//                    }
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

    function addBarSeries()
    {
        var mySeries = rankChart.createSeries(ChartView.SeriesTypeBar, "ranking", xCountry, yValuesLast);
        fileio.setBarSeries(mySeries)
//        console.log("bar series added")
//        var mySeries = rankChart.createSeries(ChartView.SeriesTypeHorizontalBar)
//        //fileio.setBarSeries(mySeries)
//        var categoryAxisY=Qt.createQmlObject('import QtCharts 2.2;BarCategoryAxis {}',rankChart);
////        var seriesValue = []
////        categoryAxisY.categories = ["2007", "2008", "2009", "2010", "2011", "2012" ]
////        categoryAxisY.categories = fileio.countries_ordered

//        fileio.setBarSeries(mySeries,categoryAxisY)
//        mySeries.axisY = categoryAxisY
//        //mySeries.BarSet = {"commands"; [1,2,3,4,5,6,7,8,9,10]}
//        var mBarSet = mySeries.append("commands", [1,2,3,4,5,6,7,8,9,10])
////        console.log(fileio.countries_ordered)
////        var mBarSet = mySeries.append("commands", fileio.dataCountriesPresent_ordered)
//       //BarSet { label: "Bob"; values: [2, 2, 3, 4, 5, 6] }
//        rankChart.axisX(mySeries).min= 0 //Math.min.apply(null, mBarSet.values)
//        rankChart.axisX(mySeries).max= 10 //Math.max.apply(null, mBarSet.values)
    }

    function removeSeries()
    {
        mainChart.removeAllSeries()
        mainChart.axisX(xTime)
        mainChart.axisY(yValues)

    }
}


