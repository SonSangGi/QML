#include <QtQml>
#include <QApplication>
#include <QQmlApplicationEngine>

#include <sqleventmodel.h>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // qml과 c++ 연동을 위해 c++파일을 등록
    // 등록시 qml에서 import하여 사용 가능
    qmlRegisterType<SqlEventModel>("sqleventmodel",1,0,"SqlEventModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
