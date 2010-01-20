#include "OgreView.h"

OgreView::OgreView(QWidget* parent) : QWidget(parent)
{
	mRenderWindow = NULL;
	mSceneMgr = NULL;
	mVp = NULL;
	widget = parent;
	visible = true;
	mouseLeftPressed = false;
	posX = 0;
	oldX = 0;

	setupResources();
}

OgreView::~OgreView()
{
	delete mRoot;
}

void OgreView::setupResources()
{	
	mRoot = new Ogre::Root();	

	Ogre::ConfigFile cf;
	cf.load("resources.cfg");

	Ogre::ConfigFile::SectionIterator seci = cf.getSectionIterator();
	Ogre::String secName, typeName, archName;
	while(seci.hasMoreElements())
	{
		secName = seci.peekNextKey();
		Ogre::ConfigFile::SettingsMultiMap* settings = seci.getNext();
		Ogre::ConfigFile::SettingsMultiMap::iterator i;
		for(i=settings->begin(); i!=settings->end(); ++i){
			typeName = i->first;
			archName = i->second;
			Ogre::ResourceGroupManager::getSingleton().addResourceLocation(archName, typeName, secName);
		}
	}

	mRoot->restoreConfig();
	mRoot->initialise(false);
}

void OgreView::createScene()
{
    mSceneMgr->setAmbientLight(Ogre::ColourValue(0.6, 0.6, 0.6));

    Ogre::Light* l = mSceneMgr->createLight("MainLight");
    l->setPosition(0, 100, 500);

    head = mSceneMgr->createEntity("head", "ogrehead.mesh");
    headNode = mSceneMgr->getRootSceneNode()->createChildSceneNode();
    headNode->attachObject(head);
	posX = headNode->getPosition().x;

    mCamera->setAutoTracking(true, headNode); 
}

void OgreView::resizeEvent(QResizeEvent *evt)
{
	if (mRenderWindow != NULL){
		mRenderWindow->windowMovedOrResized();
		mCamera->setAspectRatio(Ogre::Real(width()) / Ogre::Real(height()));
	}
}

void OgreView::paintEvent(QPaintEvent *evt)
{
    if (mRenderWindow == NULL){
        Ogre::NameValuePairList params;

		params["externalWindowHandle"] = Ogre::StringConverter::toString((size_t)(HWND)winId());

		mRenderWindow = mRoot->createRenderWindow("View", width(), height(), true, &params);	

        mSceneMgr = mRoot->getSceneManager(Ogre::ST_GENERIC);

        mCamera = mSceneMgr->createCamera("PlayerCam 1");

        mCamera->setPosition(Ogre::Vector3(0,0,200));
        mCamera->lookAt(Ogre::Vector3(0,0,-300));
        mCamera->setNearClipDistance(1);

        mCamera_Second = mSceneMgr->createCamera("PlayerCam 2");

        mCamera_Second->setPosition(Ogre::Vector3(0,0,200));
        mCamera_Second->lookAt(Ogre::Vector3(0,0,-300));
        mCamera_Second->setNearClipDistance(1);

        mCamera_Third = mSceneMgr->createCamera("PlayerCam 3");

        mCamera_Third->setPosition(Ogre::Vector3(0,0,200));
        mCamera_Third->lookAt(Ogre::Vector3(0,0,-300));
        mCamera_Third->setNearClipDistance(1);

        mCamera_Fourth = mSceneMgr->createCamera("PlayerCam 4");

        mCamera_Fourth->setPosition(Ogre::Vector3(0,0,200));
        mCamera_Fourth->lookAt(Ogre::Vector3(0,0,-300));
        mCamera_Fourth->setNearClipDistance(1);

        mVp = mRenderWindow->addViewport(mCamera, 0, 0.0, 0.0, 0.5, 0.5);
        mVp->setBackgroundColour(Ogre::ColourValue(0, 0, 0));
        mVp = mRenderWindow->addViewport(mCamera_Second, 1, 0.5, 0.0, 0.5, 0.5);
        mVp->setBackgroundColour(Ogre::ColourValue(0, 0, 0));
        mVp = mRenderWindow->addViewport(mCamera_Third, 2, 0.0, 0.5, 0.5, 0.5);
        mVp->setBackgroundColour(Ogre::ColourValue(0, 0, 0));
        mVp = mRenderWindow->addViewport(mCamera_Fourth, 3, 0.5, 0.5, 0.5, 0.5);
        mVp->setBackgroundColour(Ogre::ColourValue(0, 0, 0));

        Ogre::ResourceGroupManager::getSingleton().initialiseAllResourceGroups();
        createScene();

        Ogre::MaterialManager::getSingleton().setDefaultTextureFiltering(Ogre::TFO_BILINEAR);
        Ogre::MaterialManager::getSingleton().setDefaultAnisotropy(1);

        mCamera->setAspectRatio(Ogre::Real(mVp->getActualWidth()) / Ogre::Real(mVp->getActualHeight()));

        startTimer(10);
    } 
	update();
}

void OgreView::timerEvent(QTimerEvent* evt)
{
	update();
}

void OgreView::update()
{
	if(mRenderWindow != NULL){
		mRoot->_fireFrameStarted();
		mRenderWindow->update();
		mRoot->_fireFrameEnded();
	}
}

void OgreView::mousePressEvent(QMouseEvent* evt)
{
	visible = !visible;
	//head->setVisible(visible);
	
	if(evt->button() == Qt::LeftButton)
		mouseLeftPressed = true;
}

void OgreView::mouseReleaseEvent(QMouseEvent* evt)
{
	mouseLeftPressed = false;
}

void OgreView::mouseMoveEvent(QMouseEvent* evt)
{
	if(mouseLeftPressed){
		if(evt->x() > oldX)
			++posX;
		else
			--posX;
		headNode->setPosition(0, 0, posX);
		oldX = evt->x();
	}
}

void OgreView::addObject(Ogre::String name)
{
	Ogre::String filename = name;
	filename += ".mesh";
	Ogre::Entity* test = mSceneMgr->createEntity(name, filename);
	Ogre::SceneNode* testNode = mSceneMgr->getRootSceneNode()->createChildSceneNode();
    testNode->attachObject(test);
}