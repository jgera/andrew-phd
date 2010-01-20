#include "ExampleApplication.h"

class TutorialApplication : public ExampleApplication
{
protected:
public:
    TutorialApplication()
    {
    }

    ~TutorialApplication() 
    {
    }
protected:
    MeshPtr mGrassMesh;

    void createGrassMesh()
    {
    }

    void createScene(void)
    {
        createGrassMesh();
        mSceneMgr->setAmbientLight(ColourValue(1, 1, 1));

        mCamera->setPosition(150, 50, 150);
        mCamera->lookAt(0, 0, 0);

        Entity *robot = mSceneMgr->createEntity("robot", "robot.mesh");
        mSceneMgr->getRootSceneNode()->createChildSceneNode()->attachObject(robot);

        Plane plane;
        plane.normal = Vector3::UNIT_Y;
        plane.d = 0;
        MeshManager::getSingleton().createPlane("floor",
            ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME, plane,
            450,450,10,10,true,1,50,50,Vector3::UNIT_Z);
        Entity* pPlaneEnt = mSceneMgr->createEntity("plane", "floor");
        pPlaneEnt->setMaterialName("Examples/GrassFloor");
        pPlaneEnt->setCastShadows(false);
        mSceneMgr->getRootSceneNode()->createChildSceneNode()->attachObject(pPlaneEnt);
    }
};

#if OGRE_PLATFORM == OGRE_PLATFORM_WIN32
#define WIN32_LEAN_AND_MEAN
#include "windows.h"

INT WINAPI WinMain(HINSTANCE hInst, HINSTANCE, LPSTR strCmdLine, INT)
#else
int main(int argc, char **argv)
#endif
{
    // Create application object
    TutorialApplication app;

    try {
        app.go();
    } catch(Exception& e) {
#if OGRE_PLATFORM == OGRE_PLATFORM_WIN32 
        MessageBoxA(NULL, e.getFullDescription().c_str(), "An exception has occurred!", MB_OK | MB_ICONERROR | MB_TASKMODAL);
#else
        fprintf(stderr, "An exception has occurred: %s\n",
            e.getFullDescription().c_str());
#endif
    }

    return 0;
}
