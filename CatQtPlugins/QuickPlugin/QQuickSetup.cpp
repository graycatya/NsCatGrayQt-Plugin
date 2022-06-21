#include "QQuickSetup.h"
#include "DriverInfo.h"
#include <QFileDialog>
#include <QDir>


QQuickSetup::QQuickSetup(QObject *parent)
    : QObject(parent)
{
    InitConnect();
}

QQuickSetup::~QQuickSetup()
{
    PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_USER_CANCEL);
    exitSetup();
}

void QQuickSetup::SetTitle(const tstring &title)
{
    emit setTitle(tstringToQString(title));
}

void QQuickSetup::SetRequiredSpaceKb(long kb)
{
    m_requiredSpaceKb = kb;
    updateDriverInfo();
}

void QQuickSetup::SetInstallDirectory(const tstring &dir)
{
    m_installDirectory = tstringToQString(dir);
    emit setInstallDirectory(m_installDirectory);
    updateDriverInfo();
}

tstring QQuickSetup::GetInstallDirectory()
{
    return QStringToTCHAR(m_installDirectory);
}

void QQuickSetup::SetInstallStepDescription(const tstring &description, int progressValue)
{
    emit setInstallStepDescription(tstringToQString(description), progressValue);

    m_waitingAddItemsMutex.lock();
    m_waitingAddItems.push_back(tstringToQString(description));
    m_waitingAddItemsMutex.unlock();
}

void QQuickSetup::SetUnInstallStepDescription(const tstring &description, int progressValue)
{

}

void QQuickSetup::NsisExtractFilesFinished()
{
    emit nsisExtractFilesFinished();
}

bool QQuickSetup::IsCreateDesktopShortcutEnabled()
{
    return m_desktopShortcut;
}

bool QQuickSetup::IsAutoStartupOnBootEnabled()
{
    return m_boxAutoStartupOnBoot;
}

void QQuickSetup::InitConnect()
{
    m_addListItemAsync = std::async(std::launch::async, [this]() {
        HANDLE exitEvent = PluginContext::Instance()->GetExitEvent();
        while (WaitForSingleObject(exitEvent, 100) != WAIT_OBJECT_0) {
            m_waitingAddItemsMutex.lock();
            if (m_waitingAddItems.size() > 0) {
                QMetaObject::invokeMethod(this, [this]() {

                }, Qt::BlockingQueuedConnection);
                m_waitingAddItems.clear();
            }
            m_waitingAddItemsMutex.unlock();
        }
    });

    PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_UI_PREPARED);
}

void QQuickSetup::updateDriverInfo()
{
    int driver = DriveInfo::GetDrive(m_installDirectory.toStdWString().c_str());
    if (driver > 0) {
        float driverTotalMb = DriveInfo::GetTotalMB(driver);
        float driverFreeMb = DriveInfo::GetFreeMB(driver);

        QString strDiskInfo = QString("Required: %1MB Free: %2MB  Total: %3MB").arg(m_requiredSpaceKb / 1024).arg(driverFreeMb).arg(driverTotalMb);
    }
}

void QQuickSetup::exitSetup()
{
    HANDLE exitEvent = PluginContext::Instance()->GetExitEvent();
    if (exitEvent)
        SetEvent(exitEvent);
    if (m_addListItemAsync.valid())
        m_addListItemAsync.wait();
    emit closeed();
}

void QQuickSetup::updateInstallDirectory(QString dir)
{
    m_installDirectory = dir;
}
