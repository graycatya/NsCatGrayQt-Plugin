#include "QWidgetSetup.h"
#include "ui_QWidgetSetup.h"

QWidgetSetup::QWidgetSetup(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::QWidgetSetup)
{
    ui->setupUi(this);
}

QWidgetSetup::~QWidgetSetup()
{
    delete ui;
}
