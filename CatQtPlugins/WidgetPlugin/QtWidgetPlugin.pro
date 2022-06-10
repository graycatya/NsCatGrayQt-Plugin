TARGET = QtWidgetPlugin

QT += widgets core gui

TEMPLATE = lib
#CONFIG += staticlib
CONFIG += dynamiclib

CONFIG(debug,debug|release){
TARGET = QtWidgetPlugind
}

include($$PWD/../../NsCatGrayQtCore/NsCatGrayQtCore.pri)

SOURCES += \
    NsisQtWidgetPlugin.cpp

HEADERS += \
    $$PWD/QWidgetSetup.h \

SOURCES += \
    $$PWD/QWidgetSetup.cpp \

FORMS += \
    $$PWD/QWidgetSetup.ui
