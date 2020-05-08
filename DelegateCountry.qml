import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1



Component {
    id:testDelegate2
    Item {
        width:180
        height: 40
        Column{
//            Text {text: 'Name ' + name}
              Text {text: modelData}
        }
    }
}






