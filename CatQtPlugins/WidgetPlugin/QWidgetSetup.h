#ifndef QWIDGETSETUP_H
#define QWIDGETSETUP_H

#include <QWidget>
#include <QtGlobal>
#include <QtWidgets/QApplication>
#include <QMap>
#include <QMutex>
#include "stdafx.h"
#include <future>
#include "SetupPageInterface.h"

namespace Ui {
class QWidgetSetup;
}

class QWidgetSetup :
        public QWidget
        , public SetupPageInterface
{
    Q_OBJECT

public:
    explicit QWidgetSetup(QWidget *parent = nullptr);
    ~QWidgetSetup();

    void SetTitle(const tstring &title) override;
    void SetRequiredSpaceKb(long kb) override;
    void SetInstallDirectory(const tstring &dir) override;
    tstring GetInstallDirectory() override;
    void SetInstallStepDescription(const tstring &description, int progressValue = -1) override;
    void SetUnInstallStepDescription(const tstring &description, int progressValue = -1) override;
    void NsisExtractFilesFinished() override;
    bool IsCreateDesktopShortcutEnabled() override;
    bool IsAutoStartupOnBootEnabled() override;

private:
    void InitUi();
    void InitProperty();
    void InitConnect();

    void updateDriverInfo();
    void exitSetup();

private:
    Ui::QWidgetSetup *ui;
    long m_requiredSpaceKb;
    std::future<void> m_addListItemAsync;
    QMutex m_waitingAddItemsMutex;
    QStringList m_waitingAddItems;
};

#endif // QWIDGETSETUP_H
