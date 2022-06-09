TARGET = QtWidgetPlugin

QT += widgets core gui

TEMPLATE = lib
CONFIG += staticlib

include($$PWD/../../NsCatGrayQtCore/NsCatGrayQtCore.pri)

SOURCES += \
    NsisQtWidgetPlugin.cpp

HEADERS += \
    $$PWD/QWidgetSetup.h \

SOURCES += \
    $$PWD/QWidgetSetup.cpp \

FORMS += \
    $$PWD/QWidgetSetup.ui
