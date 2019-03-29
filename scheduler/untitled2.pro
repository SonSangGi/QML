TEMPLATE = app

QT += qml quick widgets sql

SOURCES += main.cpp \
    sqleventmodel.cpp \
    event.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    sqleventmodel.h \
    event.h
