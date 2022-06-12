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

#QtWidgetPluginSource = $$OUT_PWD\QtWidgetPlugin.dll
#QtWidgetPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtWidgetPlugin.dll
#CONFIG(debug,debug|release){
#QtWidgetPluginSource = $$OUT_PWD\QtWidgetPlugind.dll
#QtWidgetPluginNSISPluginDirFile = $$(NSIS_DIR)\Plugins\x86-unicode\QtWidgetPlugind.dll
#}

#QtWidgetPluginSourceFile = $$replace(QtWidgetPluginSource, /, \\)  # replace函数的第一个参数必须是大写，坑死了
#QtWidgetPluginNSISPluginDir = $$replace(QtWidgetPluginNSISPluginDirFile, /, \\)

## 配置file_copies
#CONFIG += file_copies

## 创建examples变量并配置
## 配置需要复制的文件或目录(支持通配符)
#examples.files = $$QtWidgetPluginSourceFile
## 配置需要复制的目标目录, $$OUT_PWD为QMake内置变量，含义为程序输出目录
## CONFIG += debug_and_release

#examples.path = $$QtWidgetPluginNSISPluginDir


## 配置COPIES
#COPIES += examples

#message($$QtWidgetPluginSourceFile)
#message($$QtWidgetPluginNSISPluginDir)
