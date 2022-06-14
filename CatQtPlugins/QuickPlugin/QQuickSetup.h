#ifndef QQUICKSETUP_H
#define QQUICKSETUP_H

#include <QObject>
#include <QtGlobal>
#include <QtWidgets/QApplication>
#include <QMap>
#include <QMutex>
#include "stdafx.h"
#include <future>
#include "SetupPageInterface.h"

class QQuickSetup :
        public QObject
        , public SetupPageInterface
{
    Q_OBJECT
public:
    explicit QQuickSetup(QObject *parent = nullptr);
    ~QQuickSetup();

    void SetTitle(const tstring &title) override;
    void SetRequiredSpaceKb(long kb) override;
    void SetInstallDirectory(const tstring &dir) override;
    tstring GetInstallDirectory() override;
    void SetInstallStepDescription(const tstring &description, int progressValue = -1) override;
    void NsisExtractFilesFinished() override;
    bool IsCreateDesktopShortcutEnabled() override;
    bool IsAutoStartupOnBootEnabled() override;

private:
    void InitConnect();

    Q_INVOKABLE void updateDriverInfo();
    Q_INVOKABLE void exitSetup();

    Q_INVOKABLE void updateInstallDirectory(QString dir);

signals:
    void setTitle(QString title);
    void setRequiredSpaceKbStr(QString str);
    void setInstallDirectory(QString dir);
    void setInstallStepDescription(QString description, int progressvalue);
    void nsisExtractFilesFinished();
    void isCreateDesktopShortcutEnabled();
    void isAutoStartupOnBootEnabled();
    void updateLanguage();
    void closeed();

private:
    long m_requiredSpaceKb;
    std::future<void> m_addListItemAsync;
    QMutex m_waitingAddItemsMutex;
    QStringList m_waitingAddItems;
    QString m_installDirectory;
    bool m_desktopShortcut = false;
    bool m_boxAutoStartupOnBoot = false;

};

#endif // QQUICKSETUP_H
