import QtQuick 2.0

Item {

    readonly property int title_width: 1920
    readonly property int title_height: 600
    property string titleText: ""
    property string titlesubText: ""
    property string accountText: ""
    property string general_path : "file:///home/sgson/general/"

    Image {
        id: background
        source: general_path + "bg_full.png"
        anchors.fill: parent
    }

    Image {
        id: backgroundmain
        source: general_path+"bg_main.png"
    }

}

