#include "QWidgetSetup.h"
#include "ui_QWidgetSetup.h"
#include "DriverInfo.h"
#include <QFileDialog>
#include <QDir>

QWidgetSetup::QWidgetSetup(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::QWidgetSetup)
{
    ui->setupUi(this);
    InitUi();
    InitProperty();
    InitConnect();
}

QWidgetSetup::~QWidgetSetup()
{
    PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_USER_CANCEL);
    exitSetup();
    delete ui;
}

void QWidgetSetup::SetTitle(const tstring &title)
{
    this->setWindowTitle(tstringToQString(title));
}

void QWidgetSetup::SetRequiredSpaceKb(long kb)
{
    m_requiredSpaceKb = kb;
    updateDriverInfo();
}

void QWidgetSetup::SetInstallDirectory(const tstring &dir)
{
    ui->SelectInstallDirEdit->setText(tstringToQString(dir));
    updateDriverInfo();
}

tstring QWidgetSetup::GetInstallDirectory()
{
    QString strDir = ui->SelectInstallDirEdit->text();
    return QStringTotstring(strDir);
}

void QWidgetSetup::SetInstallStepDescription(const tstring &description, int progressValue)
{
    QMetaObject::invokeMethod(this, [this, progressValue]() {
        if (progressValue >= 0 && progressValue <= 100) {
            ui->ProgressBarInstall->setValue(progressValue);
        }
        if(progressValue >= 0 && progressValue < 100)
        {
            ui->ToFinishedButton->setEnabled(false);
        } else {
            ui->ToFinishedButton->setEnabled(true);
        }
    }, Qt::QueuedConnection);

    m_waitingAddItemsMutex.lock();
    m_waitingAddItems.push_back(tstringToQString(description));
    m_waitingAddItemsMutex.unlock();
}

void QWidgetSetup::NsisExtractFilesFinished()
{
    QMetaObject::invokeMethod(this, [this]() {
        ui->pushButtonFinish->setEnabled(true);
    }, Qt::QueuedConnection);
}

bool QWidgetSetup::IsCreateDesktopShortcutEnabled()
{
    return ui->checkBoxDesktopShortcut->isChecked();
}

bool QWidgetSetup::IsAutoStartupOnBootEnabled()
{
    return ui->checkBoxAutoStartupOnBoot->isChecked();
}

void QWidgetSetup::InitUi()
{
    ui->SetupStacked->setCurrentIndex(0);
    ui->pushButtonFinish->setEnabled(false);

}

void QWidgetSetup::InitProperty()
{

}

void QWidgetSetup::InitConnect()
{
    connect(ui->SelectInstallDirButton, &QPushButton::clicked, [this]() {
        QString dir = QFileDialog::getExistingDirectory(this, tr("Open Directory"), "/", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
        if(!dir.isEmpty())
        {
            dir = QDir::toNativeSeparators(dir);
            ui->SelectInstallDirEdit->setText(dir);
            updateDriverInfo();
        }
    });

    connect(ui->StartInstallButton, &QPushButton::clicked, this, [this]() {
        QString strDir = ui->SelectInstallDirEdit->text();
        if (strDir.length() == 0)
            return;

        QDir dir(strDir);
        if (!dir.exists()) {
            if (!dir.mkdir(strDir)) {
                return;
            }
        }

        PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_START_EXTRACT_FILES);
        ui->SetupStacked->setCurrentIndex(1);
    });

    connect(ui->ToFinishedButton, &QPushButton::clicked, [this]() {
        ui->SetupStacked->setCurrentIndex(2);
    });

    connect(ui->pushButtonFinish, &QPushButton::clicked, [this]() {
        PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_BEFORE_FINISHED);
        exitSetup();
    });

    m_addListItemAsync = std::async(std::launch::async, [this]() {
        HANDLE exitEvent = PluginContext::Instance()->GetExitEvent();
        while (WaitForSingleObject(exitEvent, 100) != WAIT_OBJECT_0) {
            m_waitingAddItemsMutex.lock();
            if (m_waitingAddItems.size() > 0) {
                QMetaObject::invokeMethod(this, [this]() {
                    ui->listWidgetInstallDetails->addItems(m_waitingAddItems);
                    ui->listWidgetInstallDetails->scrollToBottom();
                }, Qt::BlockingQueuedConnection);
                m_waitingAddItems.clear();
            }
            m_waitingAddItemsMutex.unlock();
        }
    });

    PluginContext::Instance()->ExecuteInstallEventFunction(INSTALL_EVENT_UI_PREPARED);
}

void QWidgetSetup::updateDriverInfo()
{
    int driver = DriveInfo::GetDrive(ui->SelectInstallDirEdit->text().toStdWString().c_str());
    if (driver > 0) {
        float driverTotalMb = DriveInfo::GetTotalMB(driver);
        float driverFreeMb = DriveInfo::GetFreeMB(driver);

        QString strDiskInfo = QString("Required: %1MB Free: %2MB  Total: %3MB").arg(m_requiredSpaceKb / 1024).arg(driverFreeMb).arg(driverTotalMb);
    }
}

void QWidgetSetup::exitSetup()
{
    HANDLE exitEvent = PluginContext::Instance()->GetExitEvent();
    if (exitEvent)
        SetEvent(exitEvent);
    if (m_addListItemAsync.valid())
        m_addListItemAsync.wait();
    this->close();
}
