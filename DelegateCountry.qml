import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1

Component {
    id: countryDelegate
    Item {
        width: 180; height: 40
        Column {
            Text { text: '<b>Name:</b> ' + name }
            //Text { text: '<b>Number:</b> ' + values }
        }
    }
}



