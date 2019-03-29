#ifndef SQLEVENTMODEL_H
#define SQLEVENTMODEL_H

#include <QList>
#include <QObject>

#include "event.h"

class SqlEventModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString schYear READ schYear WRITE setSchYear NOTIFY schYearChange)
    Q_PROPERTY(QString schMonth READ schMonth WRITE setSchMonth NOTIFY schMonthChange)
    Q_PROPERTY(QString schDate READ schDate WRITE setSchDate NOTIFY schDateChange)
public:
    SqlEventModel();

    // Q_INVOKABLE : signal/slot 형태가 아니더라도 qml에서 함수에 접근할 수 있는 시스템을 제공
    // DB에서 조회한 QObject타입의 Event객체들을 리스트에 담아서 반환하는 함수
    Q_INVOKABLE QList<QObject *> eventsForDate(const QDate &date);

    QString m_schMonth;
    QString m_schYear;
    QString m_schDate;

    //getter,setter
    void setSchYear(QString value);
    void setSchMonth(QString value);
    void setSchDate(QString value);
    QString schYear();
    QString schMonth();
    QString schDate();

private:
    //DB와 연결을 위한 함수
    void createConnection();

signals:
    void schYearChange();
    void schMonthChange();
    void schDateChange();

};

#endif // SQLEVENTMODEL_H
