#include "sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QtSql/QSqlQuery>

SqlEventModel::SqlEventModel()
{
    //첫 실행 시 변수를 오늘 날짜로 설정
    QDate initDate = QDate::currentDate();

    m_schYear = QString::number(initDate.year());
    m_schMonth = QString::number(initDate.month());
    m_schDate = QString::number(initDate.day());

    // DB 생성
    createConnection();
}

void SqlEventModel::createConnection()
{
    //어떤 종류의 db에 연결할 것인지 입력 ex: addDatabase("QMYSQL", "CONNECTION NAME");
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    //저장경로 입력. :memory: 메모리에 임시로 저장
    db.setDatabaseName(":memory:");
    if(!db.open()) {
        qDebug("sql connection error");
        return;
    }

    // 쿼리를 제어하는 객체
    QSqlQuery query;

    query.exec("create table event (name TEXT, startDate DATE, startTime INT, endDate DATE,endTime INT)");
    query.exec("insert into event values('위자드랩 입사','2019-03-06','36000','2019-03-06','39600')");
    query.exec("insert into event values('3주년','2019-03-06','36000','2019-03-06','39600')");
    query.exec("insert into event values('스터디','2019-03-27','36000','2019-03-27','39600')");
    query.exec("insert into event values('강의','2019-03-27','36000','2019-03-27','39600')");
    query.exec("insert into event values('강좌','2019-03-27','36000','2019-03-27','39600')");
    query.exec("insert into event values('허예일','2019-03-27','36000','2019-03-27','39600')");
    query.exec("insert into event values('ㅠㅠ','2019-03-09','36000','2019-03-09','39600')");
    query.exec("insert into event values('기념일','2019-03-13','36000','2019-03-13','39600')");
    query.exec("insert into event values('','2019-03-15','36000','2019-03-15','39600')");
    query.exec("insert into event values('여자친구','2019-03-31','36000','2019-03-31','39600')");
    query.exec("insert into event values('태용,영범','2019-03-28','36000','2019-03-28','39600')");
    query.exec("insert into event values('인혁','2019-05-06','36000','2019-05-06','39600')");
    query.exec("insert into event values('태용','2019-06-01','36000','2019-06-01','39600')");
    query.exec("insert into event values('여자친구','2019-04-03','36000','2019-04-03','39600')");
    query.exec("insert into event values('생일','2019-05-15','36000','2019-05-15','39600')");
    query.exec("insert into event values('동기모임','2019-05-12','36000','2019-05-12','39600')");
    query.exec("insert into event values('콘서트','2019-02-15','36000','2019-02-15','39600')");
    query.exec("insert into event values('생일','2019-01-02','36000','2019-01-02','39600')");
    query.exec("insert into event values('LOL','2019-04-25','36000','2019-04-25','39600')");
    query.exec("insert into event values('여자친구','2018-12-14','36000','2018-12-14','39600')");

    query.exec("select * from event");

}

QList<QObject *> SqlEventModel::eventsForDate(const QDate &date)
{
    // 받아온 날짜 정보로 이벤트를 조회할 SQL문을 작성
    const QString queryStr = QString::fromLatin1("select * from event where '%1' >= startDate and '%1' <= endDate").arg(date.toString("yyyy-MM-dd"));

    // 쿼리를 제어하는 객체에 작성한 SQL문을 전달
    QSqlQuery query(queryStr);

    if(!query.exec())
        qDebug("Query failed");

    // 이벤트를 담을 리스트 생성
    QList<QObject*> events;

    // 조회한 이벤트를 이벤트 객체에 넣어서 리스트에 담는다.
    while(query.next()){
        Event *event = new Event(this);
        event->setName(query.value("name").toString());

        QDateTime startDate;
        startDate.setDate(query.value("startDate").toDate());
        startDate.setTime(QTime(0,0).addSecs(query.value("startTime").toInt()));
        event->setStartDate(startDate);

        QDateTime endDate;
        endDate.setDate(query.value("endDate").toDate());
        endDate.setTime(QTime(0,0).addSecs(query.value("endTime").toInt()));
        event->setEndDate(endDate);

        events.append(event);
    }

    return events;

}


void SqlEventModel::setSchYear(QString value)
{
    m_schYear = value;
    emit schYearChange();
}

void SqlEventModel::setSchMonth(QString value)
{
    m_schMonth = value;
    emit schMonthChange();
}

void SqlEventModel::setSchDate(QString value)
{
    m_schDate = value;
    emit schDateChange();
}

QString SqlEventModel::schYear()
{
    return m_schYear;
}

QString SqlEventModel::schMonth()
{
    return m_schMonth;
}
QString SqlEventModel::schDate()
{
    return m_schDate;
}





