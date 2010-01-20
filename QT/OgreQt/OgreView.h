#include <QWidget>
#include <QMouseEvent>
#include <windows.h>
#include <Ogre.h>

class OgreView : public QWidget
{
	Q_OBJECT

public:
	OgreView(QWidget* parent = 0);
	~OgreView();
	void addObject(Ogre::String);
	void update();

protected:
	void setupResources();
	//void update();
	void createScene();
	void resizeEvent(QResizeEvent* evt);
	void timerEvent(QTimerEvent* evt);
	void paintEvent(QPaintEvent* evt);
	void mousePressEvent(QMouseEvent* evt);
	void mouseReleaseEvent(QMouseEvent* evt);
	void mouseMoveEvent(QMouseEvent* evt);

	Ogre::RenderWindow* mRenderWindow;
	Ogre::SceneManager* mSceneMgr;
	Ogre::Camera* mCamera;
	Ogre::Camera* mCamera_Second;
	Ogre::Camera* mCamera_Third;
	Ogre::Camera* mCamera_Fourth;
	Ogre::Viewport* mVp;
	Ogre::Root* mRoot;
	
	Ogre::Entity* head;
	Ogre::SceneNode* headNode;

	QWidget* widget;

	bool visible;
	bool mouseLeftPressed;
	int posX;
	int oldX;
};