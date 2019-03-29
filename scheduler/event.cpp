#include "event.h"

Event::Event(QObject *parent) :
    QObject(parent)
{

}

QString Event::name() const
{
    return mName;
}

void Event::setName(const QString &name)
{
    if (name != mName) {
        mName = name;
        emit nameChanged(mName);
    }
}

QDateTime Event::startDate() const
{
    return mstartDate;
}

void Event::setStartDate(const QDateTime &startDate)
{
    if (startDate != mstartDate) {
        mstartDate = startDate;
        emit startDateChanged(mstartDate);
    }
}

QDateTime Event::endDate() const
{
    return mEndDate;
}

void Event::setEndDate(const QDateTime &endDate)
{
    if (endDate != mEndDate) {
        mEndDate = endDate;
        emit endDateChanged(mEndDate);
    }
}
