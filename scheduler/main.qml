import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

// main.cpp에 등록한 c++파일을 import
import sqleventmodel 1.0

// 윈도우용 에뮬레이터
ApplicationWindow {
    title: qsTr("Calendar")
    width: 1245+646
    height: 600
    visible: true

    // import한 c++을 생성
    SqlEventModel {
        id:eventModel
    }

    /******************* Property *********************/

    // qml 내에서 사용하기 위한 property 정의
    property date today: new Date();
    property date showDate:{
        new Date(eventModel.schYear,parseInt(eventModel.schMonth)-1,parseInt(eventModel.schDate));
    }

    //이번달의 마지막
    property int daysInMonth: new Date(today.getFullYear(),today.getMonth()+1,0).getDate();
    //이번달의 첫째 날의 요일
    property int firstDay: new Date(showDate.getFullYear(),showDate.getMonth(),1).getDay();

    // 클릭한 날짜
    property var selectedDay: showDate

    property int itemPessed: -1

    property int eventIndex: 0

    property string path : "file:///home/sgson/noname/sasaaasssassa/images/"
    property string general_path : "file:///home/sgson/general/"


    /******************* Function *********************/

    // 현재달의 마지막 날을 받아 첫째날의 요일에 따라 주일을 반환
    function weeklycount(index) {
        if (index === 28){
            if(firstDay === 0)
                return 4
        }
        if (index === 31) {
            if(firstDay === 5 || firstDay === 6)
                return 6
        }
        return 5
    }

    // 날짜를 받아 오늘인지 확인하는 함수
    function isToday(index) {
        if(today.getFullYear() !=selectedDay.getFullYear() || today.getMonth() != selectedDay.getMonth())
            return false;
        return (index === today.getDate() -1)
    }

    // 선택한 달을 받아 문자로 반환하는 함수
    function monthToString(index) {
        var str;
        index = Number(index);
        switch(index) {
        case 1: str = qsTr("Jenuary");break;
        case 2: str = qsTr("February");break;
        case 3: str =  qsTr("March");break;
        case 4: str = qsTr("April");break;
        case 5: str = qsTr("May");break;
        case 6: str = qsTr("June");break;
        case 7: str = qsTr("July");break;
        case 8: str = qsTr("August");break;
        case 9: str = qsTr("September");break;
        case 10: str = qsTr("Octover");break;
        case 11: str = qsTr("November");break;
        case 12: str = qsTr("December");break;
        default: str="";break;
        }
        return str;
    }

    // 선택한 주의 문자열을 반환하는 함수
    function dayOfWeekString(id) {
        var str;
        switch(id) {
        case Locale.Sunday:       str=qsTr("SUN");break;
        case Locale.Monday:       str=qsTr("MON");break;
        case Locale.Tuesday:      str=qsTr("TUE");break;
        case Locale.Wednesday:    str=qsTr("WEN");break;
        case Locale.Thursday:     str=qsTr("THU");break;
        case Locale.Friday:       str=qsTr("FRI");break;
        case Locale.Saturday:     str=qsTr("SAT");break;
        default:                  str=''; break;
        }
        return str;
    }

    // 'hh:mm' 형태로 값 변환
    function convert24H(index) {
        return index.substring(0, 2) +':'+ index.substring(2, 4)
    }

    /******************* Background & Header *********************/

    Image {
        id: background
        source: general_path + "bg_full.png"
        anchors.fill: parent
    }

    //타이틀 헤더
    Item {
        id:headerParent
        width:1880
        height:67

        //타이틀 상단 라인
        Image{
            id:titleTopLine
            anchors{
                top:parent.top
                left:parent.left
            }
            source:general_path+"line_title.png"
            width:parent.width
            height: 1
        }

        // 타이틀 연,월 텍스트
        Item {
            width:1000
            height: 67
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: monthToString(eventModel.schMonth)+" "+eventModel.schYear
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color:"white"
                font.pixelSize: 40
                fontSizeMode: Text.Fit
            }
        }

        // 타이틀 하단 라인
        Image{
            id:titleBottomLine
            anchors{
                top:parent.bottom
                left:parent.left
            }
            source:general_path+"line_title.png"
            width:parent.width
        }

        // 이전 달
        Item{
            id: privMonth
            width:50
            height:50
            x: 20
            y:5
            Text {
                text: qsTr("◀");
                font.pixelSize: 35
                color: "lightgrey"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var clickedDate = new Date(showDate.getFullYear(),showDate.getMonth()-1,1);
                    selectedDay = clickedDate;
                    eventModel.schYear = Qt.formatDate(selectedDay,"yyyy");
                    eventModel.schMonth = Qt.formatDate(selectedDay,"MM");
                    eventModel.schDate = Qt.formatDate(selectedDay,"d");
                }
            }
        }

        // 다음 달
        Item{
            id: nextMonth
            width:50
            height:50
            anchors.left: privMonth.right
            anchors.leftMargin: 20
            y:5
            Text {
                text: qsTr("▶")
                font.pixelSize: 35
                color: "lightgrey"
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var clickedDate = new Date(showDate.getFullYear(),showDate.getMonth()+1,1);
                    selectedDay = clickedDate;
                    eventModel.schYear = Qt.formatDate(selectedDay,"yyyy");
                    eventModel.schMonth = Qt.formatDate(selectedDay,"MM");
                    eventModel.schDate = Qt.formatDate(selectedDay,"d");
                }
            }
        }
    }


    /******************* Calendar *********************/

    // 달력
    Item {
        anchors.fill: parent
        anchors.topMargin: 67

        Item {
            id: calendar
            width: 1245
            height: 527
            focus: true

            // 주별 배경화면
            Image {
                width: sourceSize.width
                height: sourceSize.height
                source: weeklycount(daysInMonth)===4?path+"bg_line_01_schedule.png"
                                                    :(weeklycount(daysInMonth)===6?path+"bg_line_03_schedule.png"
                                                                                  :path+"bg_line_02_schedule.png")
            }

            Item {
                id: dateLabels
                anchors.top : parent.top
                anchors.left : parent.left
                anchors.leftMargin: 3
                anchors.right:parent.right
                anchors.rightMargin: 3

                width:1245-8
                height:calendar.height

                // 주별 행
                property int rows : weeklycount(daysInMonth)

                //요일
                Item {
                    id: dayLabels
                    width:parent.width
                    height:42

                    // 열 및 마진을 정함
                    Grid {
                        columns: 7
                        spacing: 1

                        // Repeater : model의 수만큼 반복시킴
                        Repeater {
                            // model : 반복될 수 or 반복할 리스트
                            model: 7

                            //
                            Rectangle {
                                color: "transparent"
                                width: 175
                                height:41

                                Text {
                                    anchors.centerIn: parent
                                    color: index === 0 ? "red":index === 6 ? "blue" : "lightgrey"
                                    fontSizeMode: Text.Fit
                                    font.pixelSize: 24

                                    text: dayOfWeekString(index)

                                }
                            }

                        }

                    }
                }

                //날짜 영역
                Item {
                    id: dateGrid
                    width: parent.width
                    anchors.top: dayLabels.bottom
                    anchors.bottom: parent.bottom

                    Grid {
                        columns: 7
                        rows: dateLabels.rows
                        spacing: 1

                        Repeater {
                            id: repeaater
                            model: firstDay+daysInMonth

                            // 날짜 박스
                            Rectangle {
                                id:dayItem
                                color: "transparent"
                                width:175
                                height: (dateGrid.height - (dateLabels.rows - 1))/dateLabels.rows

                                property bool highLighted: false
                                property color nomalColor

                                // 이벤트가 있는 날에 하이라이트 이미지
                                Image {
                                    visible: eventModel.eventsForDate(Qt.formatDate(showDate,"yyyy-MM-")+(index+1-firstDay <10?"0":"")+(index+1-firstDay)).length > 0
                                    anchors.fill: parent
                                    source: {
                                        weeklycount(daysInMonth)===4?path+"bg_schedule_01_event.png":
                                                                      (weeklycount(daysInMonth)===6?path+"bg_schedule_03_event.png"
                                                                                                   :path+"bg_schedule_01_event.png")
                                    }
                                    width : sourceSize.width
                                    height: sourceSize.height
                                    y: 52
                                    anchors.horizontalCenter:parent.horizontalCenter

                                }

                                // 이벤트가 있는 날에 닷 표시
                                Image {
                                    visible: eventModel.eventsForDate(Qt.formatDate(showDate,"yyyy-MM-")+(index+1-firstDay <10?"0":"")+(index+1-firstDay)).length > 0
                                    source: path + "bg_schedule_event_dot_n.png";
                                    width : sourceSize.width
                                    height: sourceSize.height
                                    y: 52
                                    anchors.horizontalCenter:parent.horizontalCenter
                                }

                                // 현재 날짜에 하이라이트 이미지
                                Image {
                                    anchors.fill: parent
                                    source: {
                                        isToday(index-firstDay)?weeklycount(daysInMonth)===4?path+"bg_schedule_01_today.png":
                                                                                              (weeklycount(daysInMonth)===6?path+"bg_schedule_03_today.png"
                                                                                                                           :path+"bg_schedule_01_today.png")
                                        :""
                                    }
                                }
                                // 날짜 텍스트 표시
                                Text {
                                    id:dateText
                                    text: index+1 -firstDay // 인덱스 + 1 - 요일로 현재 날짜를 구함
                                    color: isToday(index-firstDay)? "white" : (index%7 === 0 ? "red": (index ===6 || (index-6) %7===0 ? "blue" : "lightgrey"))
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    fontSizeMode: Text.Fit
                                    font.pixelSize: 36
                                    opacity: (index<firstDay) ? 0 : 1
                                }

                                MouseArea {
                                    id: dateMouse
                                    enabled: index >= firstDay
                                    anchors.fill: parent
                                    onPressed: {
                                        var clickedDate = new Date(showDate.getFullYear(),showDate.getMonth(),index+1-firstDay);
                                        selectedDay = clickedDate;
                                        eventModel.schYear = Qt.formatDate(selectedDay,"yyyy");
                                        eventModel.schMonth = Qt.formatDate(selectedDay,"MM");
                                        eventModel.schDate = Qt.formatDate(selectedDay,"d");
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }

        /******************* Event *********************/

        // 일정 상세 내용 박스
        Component {
            id:eventListDelegate
            Item {
                id: itemDelegate
                width: 639
                height: 97

                // 일정 시간 표시
                Item {
                    id:eventTime
                    width:106
                    height:96
                    anchors.leftMargin: 20
                    anchors.top:parent.top
                    anchors.topMargin: 10

                    // 일정 시작 시간
                    Label {
                        id: eventStartTime
                        height: 48
                        anchors.top: parent.top
                        anchors.topMargin: 7

                        Text{
                            width:106
                            text: "09:30"
                            anchors.topMargin: 11
                            color:"lightgrey"
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                    // 일정 시작 시간
                    Label {
                        id: eventEndTime
                        height: 48
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 7

                        Text{
                            width:106
                            text:"18:30"
                            anchors.topMargin: 11
                            color:"grey"
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                // Bar
                Item {
                    id: eventClearImage
                    width:5
                    height:96

                    Image {
                        id:clearImage
                        width: sourceSize.width
                        height:sourceSize.height
                        anchors.left: eventTime.right
                        anchors.leftMargin: 26
                        anchors.verticalCenter: parent.verticalCenter
                        source: path + "bg_schedule_color_bar_0"+(index+1%6)+".png"
                    }
                }

                // 일정 내용 텍스트 표시
                Rectangle {
                    width: 390
                    height:96
                    anchors.left: eventClearImage.right
                    anchors.leftMargin: 35
                    color: "transparent"

                    Text{
                        text: modelData.name !== "" ? modelData.name : "제목없음"
                        font.pixelSize: 32
                        color:"lightgrey"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                //하단 바
                Image {
                    width: parent.width
                    height:1
                    source: path + "list_sharing_01_line.png"
                }
            }
        }

        //
        Image {
            anchors.right: calendar.right
            anchors.rightMargin: 1
            source: path+"depth_frame.png"
        }

        Item {
            id:eventview
            width: 639
            height: 526
            anchors.left:calendar.right
            anchors.leftMargin: -6

            Item {
                id: eventListHeader
                width: parent.width
                height:42

                Text {
                    id: eventMonthDayLabel
                    text: {
                        Qt.formatDate(selectedDay,'M')+Qt.formatDate(selectedDay,'.dd')
                    }
                    width:82
                    height:parent.height
                    x:32
                    color:"lightgrey"
                    fontSizeMode: Text.Fit
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: Qt.formatDate(
                              new Date(parseInt(Qt.formatDateTime(showDate,'yyyy')),
                                       parseInt(Qt.formatDateTime(showDate,'MM'))-1,
                                       parseInt(Qt.formatDate(selectedDay,'dd'))),"dddd")

                    height: 42
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    fontSizeMode: Text.Fit
                    color: "lightgrey"
                    font.pixelSize: 24
                    verticalAlignment: Text.AlignVCenter
                }

                Image {
                    id: headerLine
                    source: path+"line_te_info_w_01.png"
                    width:639
                    height:sourceSize.height
                    anchors.bottom: parent.bottom
                }
            }

            Item {
                width: 639
                height: 485
                anchors.top: eventListHeader.bottom


                // ListView : 미리 작성해놓은 컴포넌트를 사용하여 모델의 데이터를 출력할 수 있음
                ListView {
                    id: eventList
                    width: parent.width
                    height:parent.height
                    // 리스트형식의 모델을 넣어줌
                    model: eventModel.eventsForDate(Qt.formatDate(selectedDay,"yyyy-MM-dd"));
                    // 만들어둔 Component를 연결
                    delegate: eventListDelegate
                }
            }

            Label {
                visible:eventList.count == 0
                id: noevent
                text: qsTr("NO EVENTS")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "lightgrey"
                fontSizeMode: Text.Fit
                font.pixelSize:40
                // visble : listview isempty
            }
        }

    }

}
