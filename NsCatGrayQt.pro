TARGET = NsCatGrayQtPlugin

TEMPLATE = lib
CONFIG += staticlib

include($$PWD/NsCatGrayQtCore/NsCatGrayQtCore.pri)

!isEmpty(target.path): INSTALLS += target
