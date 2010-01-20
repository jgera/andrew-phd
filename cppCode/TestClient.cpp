// TestClient.cpp : Implementation of WinMain

#include "stdafx.h"
#include "resource.h"
#include "RobotServer\_RobotServer.h"
#include "RobotServer\_RobotServer_i.c" //Generate a eyeinhand.cpp that only has this include, so don't need to declare it all the way through

// The module attribute causes WinMain to be automatically implemented for you
[ module(EXE, uuid = "{E061B6E0-C6EC-4BD2-AED6-AAD0971933C5}", 
		 name = "TestClient", 
		 helpstring = "TestClient 1.0 Type Library",
		 resource_name = "IDR_TESTCLIENT") ]
class CTestClientModule
{
	IPlatformCommand *m_platform;
public:
	CTestClientModule() : m_platform(0)
	{
	}

	HRESULT Run(int nShowCmd = SW_HIDE) throw()
	{
		HRESULT hResult = CoCreateInstance(CLSID_CPlatformCommand, NULL, CLSCTX_LOCAL_SERVER, IID_IPlatformCommand, (LPVOID*)&m_platform);
		//CLSID_CPlatformCommand is the com object for the PlatformCommand, IID_IPlatformCommand is the interface object, &m_platform is the
		//return handle. Don't worry about the other arguments
		if (hResult == S_OK)
		{
			PlatformCommandState state;
			m_platform->get_State(&state);
			if (state == Stationary)
			{
				ITaskProgress *task = 0;
				m_platform->Start(&task);
				if (task)
					task->put_Cancelled(VARIANT_BOOL(true));
			}

		}
		return hResult;
	}
// Override CAtlExeModuleT members
};
		 
