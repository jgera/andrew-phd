#include "Menu.h"

Menu::Menu(QWidget* parent) : QMenu(parent)
{
	newAct = new QAction(tr("&New"), this);
	newAct->setShortcut(tr("Ctrl+N"));
	newAct->setStatusTip(tr("Create a New Document"));

	menuBar = new QMenuBar();
}

void Menu::createMenus()
{
	fileMenu = menuBar->addMenu(tr("&File"));
	fileMenu->addAction(newAct);
}