#include <QMainWindow>
#include <QWidget>
#include <QLabel>
#include <QtGui>
#include <QSplitter>
#include <QGridLayout>
#include <QActionGroup>
#include <QScrollArea>
#include <QMenu>
#include <QMenuBar>
#include <QMessageBox>

#include "OgreView.h"

class MainWindow : public QMainWindow
{
	Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);

private slots:
	void newFile();
	void openFile();
	void plasticsStyle();
	void xpStyle();
	void about();

private:
	void createActions();
	void createMenus();
	void resizeEvent(QResizeEvent* evt);

	QWidget* centralWidget;
	QSplitter* splitter;
	QScrollArea* ogreArea;
	OgreView* ogreView;
	QActionGroup* alignmentGroup;
	QMenu* fileMenu;
	QMenu* editMenu;
	QMenu* styleMenu;
	QMenu* helpMenu;
	QAction* newAct;
	QAction* openAct;
	QAction* xpAct;
	QAction* plasticsAct;
	QAction* quitAct;
	QAction* aboutAct;
};