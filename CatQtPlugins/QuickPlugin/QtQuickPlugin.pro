TARGET = QtQuickPlugin

QT += widgets core gui quick

TEMPLATE = lib
#CONFIG += staticlib
CONFIG += dynamiclib

CONFIG += console

CONFIG(debug,debug|release){
TARGET = QtQuickPlugind
}

include($$PWD/../../NsCatGrayQtCore/NsCatGrayQtCore.pri)


RESOURCES += \
    Resources/Resource.qrc

QtQuickPluginSource = $$OUT_PWD\release\QtQuickPlugin.dll
QtQuickPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtQuickPlugin.dll
CONFIG(debug,debug|release){
QtQuickPluginSource = $$OUT_PWD\debug\QtQuickPlugind.dll
QtQuickPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtQuickPlugind.dll
}

QtQuickPluginSourceFile = $$replace(QtQuickPluginSource, /, \\)
QtQuickPluginNSISPluginDir = $$replace(QtQuickPluginNSISPluginDirFile, /, \\)

QMAKE_POST_LINK += copy /Y $$QtQuickPluginSourceFile $$QtQuickPluginNSISPluginDir

SOURCES += \
    NsisQtQuickPlugin.cpp \
    QQuickSetup.cpp

HEADERS += \
    QQuickSetup.h
