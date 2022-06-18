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
    NsisQtWidgetPlugin.cpp \
    Dllmain.cpp

HEADERS += \
    $$PWD/QWidgetSetup.h \

SOURCES += \
    $$PWD/QWidgetSetup.cpp \

FORMS += \
    $$PWD/QWidgetSetup.ui

QtWidgetPluginSource = $$OUT_PWD\release\QtWidgetPlugin.dll
QtWidgetPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtWidgetPlugin.dll
CONFIG(debug,debug|release){
QtWidgetPluginSource = $$OUT_PWD\debug\QtWidgetPlugind.dll
QtWidgetPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtWidgetPlugind.dll
}

QtWidgetPluginSourceFile = $$replace(QtWidgetPluginSource, /, \\)
QtWidgetPluginNSISPluginDir = $$replace(QtWidgetPluginNSISPluginDirFile, /, \\)

QMAKE_POST_LINK += copy /Y $$QtWidgetPluginSourceFile $$QtWidgetPluginNSISPluginDir
