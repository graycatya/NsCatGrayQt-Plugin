TEMPLATE = subdirs

SUBDIRS += \
    CatQtPlugins/WidgetPlugin/QtWidgetPlugin.pro \
    CatQtPlugins/QuickPlugin/QtQuickPlugin.pro

# 顺序编译
CONFIG += ordered

