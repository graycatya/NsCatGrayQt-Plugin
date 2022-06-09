#ifndef QWIDGETSETUP_H
#define QWIDGETSETUP_H

#include <QWidget>

namespace Ui {
class QWidgetSetup;
}

class QWidgetSetup : public QWidget
{
    Q_OBJECT

public:
    explicit QWidgetSetup(QWidget *parent = nullptr);
    ~QWidgetSetup();

private:
    Ui::QWidgetSetup *ui;
};

#endif // QWIDGETSETUP_H
