#ifndef EVENT_H
#define EVENT_H

#include <QObject>
#include <QDateTime>
#include <QString>

class Event : public QObject
{
    Q_OBJECT

    //QML과 C++간 데이터바인딩을 위해 사용
    //Q_PROPERTY(type qml에서 호출할 이름, READ getter, WRITE setter, NOTIFY signal);
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime startDate READ startDate WRITE setStartDate NOTIFY startDateChanged)
    Q_PROPERTY(QDateTime endDate READ endDate WRITE setEndDate NOTIFY endDateChanged)
public:
    //explicit 자동 형변환을 막음
    explicit Event(QObject *parent = 0);

    // DB와 QML에서 사용하기 위한 멤버변수의 getter, setter 선언
    // 함수 뒤에 const는 함수 안에서 값을 변경할 수 없게 만듬
    QString name() const;
    void setName(const QString &name);

    QDateTime startDate() const;
    void setStartDate(const QDateTime &startDate);

    QDateTime endDate() const;
    void setEndDate(const QDateTime &startDate);

signals:
    // Signal: 사용자가 객체에서 행동을 했을 때 발생하는 신호
    // Slot  : Signal이 발생했을 때의 처리 방식을 정의

    // signals에 선언된 함수는 emit으로 시그널 발생
    // 시그널 발생 시 QML에서 바인딩된 다른 곳에서도 데이터가 변경됨(QML에서 자동으로 값을 읽음)
    // 변경을 알리는 signal을 명시
    void nameChanged(const QString &name);
    void startDateChanged(const QDateTime &startDate);
    void endDateChanged(const QDateTime &endDate);

private:
    QString mName;
    QDateTime mstartDate;
    QDateTime mEndDate;
};

#endif




//Q_PROPERTY 외에 Connect(&Widget1, SIGNAL(clicked()), &Widget2,SLOT(show())) 함수를 사용하여 시그널 슬롯 활용
