#include "stdafx.h"
#include "QQuickSetup.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>

wchar_t *QString2Wchar(QString buf)
{
    return (wchar_t*)reinterpret_cast<const wchar_t *>(buf.utf16());
}


QString Wchar2QString(wchar_t *buf)
{
    return QString::fromWCharArray(buf);
}

#define NSMETHOD_INIT() do {\
        PluginContext::Instance()->SetExtraParameters(extra); \
        PluginContext::Instance()->SetParentHwnd(hwndParent); \
        if(extra) { \
        extra->RegisterPluginCallback(PluginContext::Instance()->pluginHandle(), PluginCallback); } \
        EXDLL_INIT(); } while(false)

static UINT_PTR PluginCallback(enum NSPIM msg) {
    return 0;
}

NSISAPI ShowSetupUI(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();

    TCHAR szTitle[MAX_PATH] = { 0 };
    popstring(szTitle);

    TCHAR szDefaultInstallDir[MAX_PATH] = { 0 };
    popstring(szDefaultInstallDir);

    TCHAR szNsisPluginDir[MAX_PATH] = { 0 };
    popstring(szNsisPluginDir);

    // Start show Qt UI
    if (_tcslen(szNsisPluginDir) > 0) {
        QApplication::addLibraryPath(tstringToQString(szNsisPluginDir));
    }

#if (QT_VERSION >= QT_VERSION_CHECK(5, 6, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    int argc = 1;
    char currentPath[MAX_PATH] = { 0 };
    GetModuleFileNameA(NULL, currentPath, MAX_PATH);
    char *argv[2] = { {currentPath}, {} };
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickSetup *mainPage = new QQuickSetup();
    engine.rootContext()->setContextProperty("qquicksetup", mainPage);

    PluginContext::Instance()->SetSetupPage(mainPage);

    const QUrl url(QStringLiteral("qrc:///qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    mainPage->SetTitle(szTitle);
    mainPage->SetInstallDirectory(szDefaultInstallDir);
    app.exec();
}

NSISAPI OutputDebugInfo(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();

    TCHAR szInfo[1024] = { 0 };
    popstring(szInfo);

    TCHAR szAllInfo[1124] = { 0 };
    StringCchPrintf(szAllInfo, 1124, TEXT("[NSIS-UI-Plugin] %s\r\n"), szInfo);
    OutputDebugString(szAllInfo);
}

NSISAPI BindInstallEventToNsisFunc(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();

    TCHAR szEventName[MAX_PATH] = { 0 };
    popstring(szEventName);
    long callbackFuncAddress = popint();

    PluginContext::Instance()->BindInstallEvent(szEventName, callbackFuncAddress);
}

NSISAPI BindButtonClickedEventToNsisFunc(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();

    TCHAR szControlName[MAX_PATH] = { 0 };
    popstring(szControlName);

    long callbackFuncAddress = popint();

    PluginContext::Instance()->BindButtonClickedEvent(szControlName, callbackFuncAddress);
}

NSISAPI NsisExtractFilesFinished(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();

    if (PluginContext::Instance()->GetSetupPage()) {
        PluginContext::Instance()->GetSetupPage()->NsisExtractFilesFinished();
    }
}


NSISAPI SetInstallDirectory(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    TCHAR szDir[MAX_PATH] = { 0 };
    popstring(szDir);

    if (PluginContext::Instance()->GetSetupPage()) {
        PluginContext::Instance()->GetSetupPage()->SetInstallDirectory(szDir);
    }
}

NSISAPI GetInstallDirectory(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    tstring strDir;
    if (PluginContext::Instance()->GetSetupPage()) {
        strDir = PluginContext::Instance()->GetSetupPage()->GetInstallDirectory();
    }
    pushstring(strDir.c_str());
}


NSISAPI SetInstallStepDescription(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    TCHAR szDescription[MAX_PATH] = { 0 };
    long percent = -1;

    popstring(szDescription);
    percent = popint();

    if (PluginContext::Instance()->GetSetupPage()) {
        PluginContext::Instance()->GetSetupPage()->SetInstallStepDescription(szDescription, percent);
    }
}

NSISAPI SetUnInstallStepDescription(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    TCHAR szDescription[MAX_PATH] = { 0 };
    long percent = -1;

    popstring(szDescription);
    percent = popint();

    if (PluginContext::Instance()->GetSetupPage()) {
        PluginContext::Instance()->GetSetupPage()->SetUnInstallStepDescription(szDescription, percent);
    }
}

NSISAPI IsCreateDesktopShortcutEnabled(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    long enabled = 0;

    if (PluginContext::Instance()->GetSetupPage()) {
        enabled = PluginContext::Instance()->GetSetupPage()->IsCreateDesktopShortcutEnabled() ? 1 : 0;
    }
    pushint(enabled);
}

NSISAPI IsAutoStartupOnBootEnabled(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    long enabled = 0;

    if (PluginContext::Instance()->GetSetupPage()) {
        enabled = PluginContext::Instance()->GetSetupPage()->IsAutoStartupOnBootEnabled() ? 1 : 0;
    }
    pushint(enabled);
}

NSISAPI BackgroundRun(HWND hwndParent, int stringSize, TCHAR *variables, stack_t **stacktop, ExtraParameters *extra) {
    NSMETHOD_INIT();
    long nsisFuncAddress = popint();

    std::thread t = std::thread([nsisFuncAddress]() {
        PluginContext::Instance()->ExecuteNsisFunction(nsisFuncAddress - 1);
    });
    t.detach();
}
