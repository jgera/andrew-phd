#include <QMenu>
#include <QMenuBar>
#include <QAction>

class Menu : QMenu
{
	Q_OBJECT

public:
	Menu(QWidget* parent = 0); 

private:
	void createMenus();

	QMenu* fileMenu;
	QMenuBar* menuBar;
	QAction* newAct;
};