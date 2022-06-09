HEADERS += \
    $$PWD/DriverInfo.h \
    $$PWD/InstallEvent.h \
    $$PWD/PluginCommon.h \
    $$PWD/PluginContext.h \
    $$PWD/SetupPageInterface.h \
    $$PWD/resource.h \
    $$PWD/stdafx.h

SOURCES += \
    $$PWD/DriverInfo.cpp \
    $$PWD/PluginContext.cpp \
    $$PWD/dllmain.cpp \
    $$PWD/stdafx.cpp


LIBS += -luser32 -lshell32 -ladvapi32
