/*
 *		This Code Was Created By Lionel Brits & Jeff Molofee 2000
 *		A HUGE Thanks To Fredric Echols For Cleaning Up
 *		And Optimizing The Base Code, Making It More Flexible!
 *		If You've Found This Code Useful, Please Let Me Know.
 *		Visit My Site At nehe.gamedev.net
 */

#include <windows.h>		// Header File For Windows
#include <math.h>			// Math Library Header File
#include <stdio.h>			// Header File For Standard Input/Output
#include <gl\gl.h>			// Header File For The OpenGL32 Library
#include <gl\glu.h>			// Header File For The GLu32 Library
//#include <resource.h>
#include <stdarg.h>			// Header File For Variable Argument Routines
#include <functions.h>
//#include <gl\glaux.h>		// Header File For The Glaux Library



#define BUFSIZE MAX_PATH


HDC			hDC=NULL;		// Private GDI Device Context
HGLRC		hRC=NULL;		// Permanent Rendering Context
HWND		hWnd=NULL;		// Holds Our Window Handle
HINSTANCE	hInstance;		// Holds The Instance Of The Application

bool	keys[256];			// Array Used For The Keyboard Routine
bool	active=TRUE;		// Window Active Flag Set To TRUE By Default
bool	fullscreen=TRUE;	// Fullscreen Flag Set To Fullscreen Mode By Default
bool	blend;				// Blending ON/OFF
bool	bp;					// B Pressed?
bool	fp;					// F Pressed?

const float piover180 = 0.0174532925f;
float heading;
float xpos = 0.4;
float zpos = -0.04;
float ypos = 1.2;

GLfloat	yrot = 91.5;				// Y Rotation
GLfloat walkbias;
GLfloat walkbiasangle = 0;
GLfloat lookupdown = 0.0f;
GLfloat	z=0.0f;				// Depth Into The Screen

GLuint	filter;				// Which Filter To Use
GLuint	*texture;			// Pointer to the texture array
GLuint	base;				// Base Display List For The Font Set
GLfloat	cnt1;				// 1st Counter Used To Move Text & For Coloring
GLfloat	cnt2;				// 2nd Counter Used To Move Text & For Coloring
//GLuint	texture[7];			// Storage For 7 Textures
int numSectors = 0;	//Global variable


typedef struct tagVERTEX
{
	float x, y, z;
	float u, v;
} VERTEX;

typedef struct tagTRIANGLE
{
	VERTEX vertex[3];
} TRIANGLE;

typedef struct tagSECTOR
{
	int numtriangles;
	TRIANGLE* triangle;
} SECTOR;
SECTOR *sector; 
LRESULT	CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);	// Declaration For WndProc

void readstr(FILE *f,char *string)
{
	do
	{
		fgets(string, 255, f);
	} while ((string[0] == '/') || (string[0] == '\n'));
	return;
}

void SetupWorld()
{
	//Reading a txt file containing all the filenames
	float x, y, z, u, v;
	int numtriangles; 	
	FILE *filein;
	FILE *allFiles;	
	char oneline[255];
	//Temporary module until i figure out how to use the window api
	//Opens a txt, and loads up all the filenames into a string array
	allFiles = fopen("allFiles.txt", "rt"); 
	readstr(allFiles,oneline);
	sscanf(oneline, "NUMOFSECTORS %d\n", &numSectors); //Get the number of filenames in the txt file

	//Get the size of the variables; sector and filnames sorted		
	sector = (SECTOR *)malloc(numSectors*sizeof(*sector));
	char **filenames = (char **)malloc(numSectors*sizeof(*filenames));	
	for (int i = 0; i < numSectors; i++)
	{
		filenames[i] = (char *)malloc(50*sizeof(*filenames[0]));		
	}

	//char filenames[100][50]; //shouldn't be hard coded size
	//This is code trying to dynamically assign the size of the filename array
	//char **filenames = (char**)malloc(numSectors*sizeof(char*));
	//for (int i = 0; i<=50; ++i)
	//{
	//	filenames[i] = (char*)malloc(50*sizeof(char));
	//}
	///////////////////////////////////

	//This puts all the txt filenames into the array, this is not the best way right now to code, could
	//be more condensed without this module, but this is to structure it for better code later.
	for (int counter = 0; counter < numSectors; counter++)
	{
		readstr(allFiles,oneline);
		sscanf(oneline, "%s\n", filenames[counter]);
	}
	///////////////////////////////////////
	
	//This loads the text data into 	
	for (int counter = 0; counter < numSectors; counter++)
	{
		filein = fopen(filenames[counter], "rt");
		readstr(filein,oneline);
		sscanf(oneline, "NUMPOLLIES %d\n", &numtriangles);
		sector[counter].triangle = new TRIANGLE[numtriangles];
		sector[counter].numtriangles = numtriangles;
		for (int loop = 0; loop < numtriangles; loop++)
		{
			for (int vert = 0; vert < 3; vert++)
			{
				readstr(filein,oneline);
				sscanf(oneline, "%f %f %f %f %f", &x, &z, &y, &v, &u); // Conversion Z axis = Y axis, image coordinates has to be rotated 90 degrees anti clockwise
				sector[counter].triangle[loop].vertex[vert].x = -x;
				sector[counter].triangle[loop].vertex[vert].y = y;
				sector[counter].triangle[loop].vertex[vert].z = z;
				sector[counter].triangle[loop].vertex[vert].u = u;
				sector[counter].triangle[loop].vertex[vert].v = 1-v;
			}
		}
		fclose(filein);
	}	
	///////////////////////////////////////

	return;
}

//AUX_RGBImageRec *LoadBMP(char *Filename)                // Loads A Bitmap Image
//{
//        FILE *File=NULL;                                // File Handle
//
//        if (!Filename)                                  // Make Sure A Filename Was Given
//        {
//                return NULL;                            // If Not Return NULL
//        }
//
//        File=fopen(Filename,"r");                       // Check To See If The File Exists
//
//        if (File)                                       // Does The File Exist?
//        {
//                fclose(File);                           // Close The Handle
//                return auxDIBImageLoad(Filename);       // Load The Bitmap And Return A Pointer
//        }
//        return NULL;                                    // If Load Failed Return NULL
//}
bool NeHeLoadBitmap(LPTSTR szFileName, GLuint &texid)					// Creates Texture From A Bitmap File
{
	HBITMAP hBMP;														// Handle Of The Bitmap
	BITMAP	BMP;														// Bitmap Structure

	glGenTextures(1, &texid);											// Create The Texture
	hBMP=(HBITMAP)LoadImage(GetModuleHandle(NULL), szFileName, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION | LR_LOADFROMFILE );

	if (!hBMP)															// Does The Bitmap Exist?
		return FALSE;													// If Not Return False

	GetObject(hBMP, sizeof(BMP), &BMP);									// Get The Object
																		// hBMP:        Handle To Graphics Object
																		// sizeof(BMP): Size Of Buffer For Object Information
																		// &BMP:        Buffer For Object Information

	glPixelStorei(GL_UNPACK_ALIGNMENT, 4);								// Pixel Storage Mode (Word Alignment / 4 Bytes)

	// Typical Texture Generation Using Data From The Bitmap
	glBindTexture(GL_TEXTURE_2D, texid);								// Bind To The Texture ID
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);	// Linear Min Filter
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);	// Linear Mag Filter
	glTexImage2D(GL_TEXTURE_2D, 0, 3, BMP.bmWidth, BMP.bmHeight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, BMP.bmBits);

	DeleteObject(hBMP);													// Delete The Object

	return TRUE;														// Loading Was Successful
}

GLvoid ReSizeGLScene(GLsizei width, GLsizei height)		// Resize And Initialize The GL Window
{
	if (height==0)										// Prevent A Divide By Zero By
	{
		height=1;										// Making Height Equal One
	}

	glViewport(0,0,width,height);						// Reset The Current Viewport

	glMatrixMode(GL_PROJECTION);						// Select The Projection Matrix
	glLoadIdentity();									// Reset The Projection Matrix

	// Calculate The Aspect Ratio Of The Window
	gluPerspective(45.0f,(GLfloat)width/(GLfloat)height,0.1f,100.0f);

	glMatrixMode(GL_MODELVIEW);							// Select The Modelview Matrix
	glLoadIdentity();									// Reset The Modelview Matrix
}

int InitGL(GLvoid)										// All Setup For OpenGL Goes Here
{
	FILE *allBMP;
	allBMP = fopen("allBMP.txt", "rt"); 
	int numBMP = 0;	
	char oneline[255];
	readstr(allBMP,oneline);
	sscanf(oneline, "NUMOFBMP %d\n", &numBMP); //Get the number of filenames in the txt file

	//Dynamically assigning a 2D array of how ever many strings there are needed with 50 characters per string
	// Texture 1D array is also created
	char **BMPnames = (char **)malloc(numBMP*sizeof(*BMPnames));	
	texture = (GLuint *)malloc(numBMP*sizeof(GLuint));
	for (int i = 0; i < numBMP; i++)
	{
		BMPnames[i] = (char *)malloc(50*sizeof(*BMPnames[0]));		
	}
	
	// Put the image file names into the created 2D array
	for (int counter = 0; counter < numBMP; counter++)
	{
		readstr(allBMP,oneline);
		sscanf(oneline, "%s\n", BMPnames[counter]);
	}

	for (int counter = 0; counter < numBMP; counter++)
	{
		if (!NeHeLoadBitmap(BMPnames[counter], texture[counter]))					// Load The Bitmap
		return FALSE;
	}
	glEnable(GL_TEXTURE_2D);							// Enable Texture Mapping
	glBlendFunc(GL_SRC_ALPHA,GL_ONE);					// Set The Blending Function For Translucency
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);				// This Will Clear The Background Color To Black
	glClearDepth(1.0);									// Enables Clearing Of The Depth Buffer
	glDepthFunc(GL_LESS);								// The Type Of Depth Test To Do
	glEnable(GL_DEPTH_TEST);							// Enables Depth Testing
	glShadeModel(GL_SMOOTH);							// Enables Smooth Color Shading
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);	// Really Nice Perspective Calculations

	SetupWorld();
	BuildFont();
	//CoInitialize(0);
	//IPlatformCommand *m_platform;
	//HRESULT hResult = CoCreateInstance(CLSID_CPlatformCommand, NULL, CLSCTX_LOCAL_SERVER, IID_IPlatformCommand, (LPVOID*)&m_platform);
	::CoInitialize(NULL);
	//// Create an instance of the Word application and obtain the
	//// pointer to the application's IDispatch interface.
	//CLSID clsid;
	//HRESULT hr;
	//IUnknown* pUnk;

	//CLSIDFromProgID(L"Word.Application",&clsid);
	//hr = ::CoCreateInstance( clsid, NULL, CLSCTX_SERVER,IID_IUnknown, (void**) &pUnk);

	return TRUE;										// Initialization Went OK
}

int DrawGLScene(GLvoid)									// Here's Where We Do All The Drawing
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	// Clear The Screen And The Depth Buffer
	glLoadIdentity();									// Reset The View

	GLfloat x_m, y_m, z_m, u_m, v_m;
	GLfloat xtrans = -xpos;
	GLfloat ztrans = -zpos;
	GLfloat ytrans = -walkbias-ypos;	
	GLfloat sceneroty = 360.0f - yrot;
	//glRasterPos2f(-0.45f+0.05f*float(cos(xtrans)), 0.32f*float(sin(ztrans)));
 	//glPrint("Active OpenGL Text With NeHe");	// Print GL Text To The Screen	
	int numtriangles;

	glRotatef(lookupdown,1.0f,0,0);
	glRotatef(sceneroty,0,1.0f,0);
	
	glTranslatef(xtrans, ytrans, ztrans);	
	//glTranslatef(0.0f,0.0f,-1.0f);
	//glColor3f(1.0f*float(cos(cnt1)),1.0f*float(sin(cnt2)),1.0f-0.5f*float(cos(cnt1+cnt2)));
	glRasterPos2f(-0.45f, -0.25f);
 	glPrint("Active OpenGL Text With NeHe - %7.2f", cnt1);	// Print GL Text To The Screen
	cnt1+=0.051f;										// Increase The First Counter
	cnt2+=0.005f;

	
////////////////////////////////////////////////
// Process for creating each triangle
	//int numOfSectors = sizeof(sector)/8; //work out how many sectors are required
	for(int sectorCounter = 0; sectorCounter < numSectors; sectorCounter++)
	{
		glBindTexture(GL_TEXTURE_2D, texture[sectorCounter]);
		numtriangles = sector[sectorCounter].numtriangles;
		for (int loop_m = 0; loop_m < numtriangles; loop_m++)
		{
			glBegin(GL_TRIANGLES);
				glNormal3f( 0.0f, 0.0f, 1.0f);
				x_m = sector[sectorCounter].triangle[loop_m].vertex[0].x;
				y_m = sector[sectorCounter].triangle[loop_m].vertex[0].y;
				z_m = sector[sectorCounter].triangle[loop_m].vertex[0].z;
				u_m = sector[sectorCounter].triangle[loop_m].vertex[0].u;
				v_m = sector[sectorCounter].triangle[loop_m].vertex[0].v;
				glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);
				
				x_m = sector[sectorCounter].triangle[loop_m].vertex[1].x;
				y_m = sector[sectorCounter].triangle[loop_m].vertex[1].y;
				z_m = sector[sectorCounter].triangle[loop_m].vertex[1].z;
				u_m = sector[sectorCounter].triangle[loop_m].vertex[1].u;
				v_m = sector[sectorCounter].triangle[loop_m].vertex[1].v;
				glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);
				
				x_m = sector[sectorCounter].triangle[loop_m].vertex[2].x;
				y_m = sector[sectorCounter].triangle[loop_m].vertex[2].y;
				z_m = sector[sectorCounter].triangle[loop_m].vertex[2].z;
				u_m = sector[sectorCounter].triangle[loop_m].vertex[2].u;
				v_m = sector[sectorCounter].triangle[loop_m].vertex[2].v;
				glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);
			glEnd();
		}
	}
////////////////////////////////////////////////
	return TRUE;										// Everything Went OK
}

GLvoid KillGLWindow(GLvoid)								// Properly Kill The Window
{
	if (fullscreen)										// Are We In Fullscreen Mode?
	{
		ChangeDisplaySettings(NULL,0);					// If So Switch Back To The Desktop
		ShowCursor(TRUE);								// Show Mouse Pointer
	}

	if (hRC)											// Do We Have A Rendering Context?
	{
		if (!wglMakeCurrent(NULL,NULL))					// Are We Able To Release The DC And RC Contexts?
		{
			MessageBox(NULL,"Release Of DC And RC Failed.","SHUTDOWN ERROR",MB_OK | MB_ICONINFORMATION);
		}

		if (!wglDeleteContext(hRC))						// Are We Able To Delete The RC?
		{
			MessageBox(NULL,"Release Rendering Context Failed.","SHUTDOWN ERROR",MB_OK | MB_ICONINFORMATION);
		}
		hRC=NULL;										// Set RC To NULL
	}

	if (hDC && !ReleaseDC(hWnd,hDC))					// Are We Able To Release The DC
	{
		MessageBox(NULL,"Release Device Context Failed.","SHUTDOWN ERROR",MB_OK | MB_ICONINFORMATION);
		hDC=NULL;										// Set DC To NULL
	}

	if (hWnd && !DestroyWindow(hWnd))					// Are We Able To Destroy The Window?
	{
		MessageBox(NULL,"Could Not Release hWnd.","SHUTDOWN ERROR",MB_OK | MB_ICONINFORMATION);
		hWnd=NULL;										// Set hWnd To NULL
	}

	if (!UnregisterClass("OpenGL",hInstance))			// Are We Able To Unregister Class
	{
		MessageBox(NULL,"Could Not Unregister Class.","SHUTDOWN ERROR",MB_OK | MB_ICONINFORMATION);
		hInstance=NULL;									// Set hInstance To NULL
	}
	KillFont();
	CoUninitialize();
}

/*	This Code Creates Our OpenGL Window.  Parameters Are:					*
 *	title			- Title To Appear At The Top Of The Window				*
 *	width			- Width Of The GL Window Or Fullscreen Mode				*
 *	height			- Height Of The GL Window Or Fullscreen Mode			*
 *	bits			- Number Of Bits To Use For Color (8/16/24/32)			*
 *	fullscreenflag	- Use Fullscreen Mode (TRUE) Or Windowed Mode (FALSE)	*/
 
BOOL CreateGLWindow(char* title, int width, int height, int bits, bool fullscreenflag)
{
	GLuint		PixelFormat;			// Holds The Results After Searching For A Match
	WNDCLASS	wc;						// Windows Class Structure
	DWORD		dwExStyle;				// Window Extended Style
	DWORD		dwStyle;				// Window Style
	RECT		WindowRect;				// Grabs Rectangle Upper Left / Lower Right Values
	WindowRect.left=(long)0;			// Set Left Value To 0
	WindowRect.right=(long)width;		// Set Right Value To Requested Width
	WindowRect.top=(long)0;				// Set Top Value To 0
	WindowRect.bottom=(long)height;		// Set Bottom Value To Requested Height

	fullscreen=fullscreenflag;			// Set The Global Fullscreen Flag

	hInstance			= GetModuleHandle(NULL);				// Grab An Instance For Our Window
	wc.style			= CS_HREDRAW | CS_VREDRAW | CS_OWNDC;	// Redraw On Size, And Own DC For Window.
	wc.lpfnWndProc		= (WNDPROC) WndProc;					// WndProc Handles Messages
	wc.cbClsExtra		= 0;									// No Extra Window Data
	wc.cbWndExtra		= 0;									// No Extra Window Data
	wc.hInstance		= hInstance;							// Set The Instance
	wc.hIcon			= LoadIcon(NULL, IDI_WINLOGO);			// Load The Default Icon
	wc.hCursor			= LoadCursor(NULL, IDC_ARROW);			// Load The Arrow Pointer
	wc.hbrBackground	= NULL;									// No Background Required For GL
	wc.lpszMenuName		= NULL;									// We Don't Want A Menu
	wc.lpszClassName	= "OpenGL";								// Set The Class Name

	if (!RegisterClass(&wc))									// Attempt To Register The Window Class
	{
		MessageBox(NULL,"Failed To Register The Window Class.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;											// Return FALSE
	}
	
	if (fullscreen)												// Attempt Fullscreen Mode?
	{
		DEVMODE dmScreenSettings;								// Device Mode
		memset(&dmScreenSettings,0,sizeof(dmScreenSettings));	// Makes Sure Memory's Cleared
		dmScreenSettings.dmSize=sizeof(dmScreenSettings);		// Size Of The Devmode Structure
		dmScreenSettings.dmPelsWidth	= width;				// Selected Screen Width
		dmScreenSettings.dmPelsHeight	= height;				// Selected Screen Height
		dmScreenSettings.dmBitsPerPel	= bits;					// Selected Bits Per Pixel
		dmScreenSettings.dmFields=DM_BITSPERPEL|DM_PELSWIDTH|DM_PELSHEIGHT;

		// Try To Set Selected Mode And Get Results.  NOTE: CDS_FULLSCREEN Gets Rid Of Start Bar.
		if (ChangeDisplaySettings(&dmScreenSettings,CDS_FULLSCREEN)!=DISP_CHANGE_SUCCESSFUL)
		{
			// If The Mode Fails, Offer Two Options.  Quit Or Use Windowed Mode.
			if (MessageBox(NULL,"The Requested Fullscreen Mode Is Not Supported By\nYour Video Card. Use Windowed Mode Instead?","NeHe GL",MB_YESNO|MB_ICONEXCLAMATION)==IDYES)
			{
				fullscreen=FALSE;		// Windowed Mode Selected.  Fullscreen = FALSE
			}
			else
			{
				// Pop Up A Message Box Letting User Know The Program Is Closing.
				MessageBox(NULL,"Program Will Now Close.","ERROR",MB_OK|MB_ICONSTOP);
				return FALSE;									// Return FALSE
			}
		}
	}

	if (fullscreen)												// Are We Still In Fullscreen Mode?
	{
		dwExStyle=WS_EX_APPWINDOW;								// Window Extended Style
		dwStyle=WS_POPUP;										// Windows Style
		ShowCursor(FALSE);										// Hide Mouse Pointer
	}
	else
	{
		dwExStyle=WS_EX_APPWINDOW | WS_EX_WINDOWEDGE;			// Window Extended Style
		dwStyle=WS_OVERLAPPEDWINDOW;							// Windows Style
	}

	AdjustWindowRectEx(&WindowRect, dwStyle, FALSE, dwExStyle);		// Adjust Window To True Requested Size

	// Create The Window
	if (!(hWnd=CreateWindowEx(	dwExStyle,							// Extended Style For The Window
								"OpenGL",							// Class Name
								title,								// Window Title
								dwStyle |							// Defined Window Style
								WS_CLIPSIBLINGS |					// Required Window Style
								WS_CLIPCHILDREN,					// Required Window Style
								0, 0,								// Window Position
								WindowRect.right-WindowRect.left,	// Calculate Window Width
								WindowRect.bottom-WindowRect.top,	// Calculate Window Height
								NULL,								// No Parent Window
								NULL,								// No Menu
								hInstance,							// Instance
								NULL)))								// Dont Pass Anything To WM_CREATE
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Window Creation Error.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	static	PIXELFORMATDESCRIPTOR pfd=				// pfd Tells Windows How We Want Things To Be
	{
		sizeof(PIXELFORMATDESCRIPTOR),				// Size Of This Pixel Format Descriptor
		1,											// Version Number
		PFD_DRAW_TO_WINDOW |						// Format Must Support Window
		PFD_SUPPORT_OPENGL |						// Format Must Support OpenGL
		PFD_DOUBLEBUFFER,							// Must Support Double Buffering
		PFD_TYPE_RGBA,								// Request An RGBA Format
		bits,										// Select Our Color Depth
		0, 0, 0, 0, 0, 0,							// Color Bits Ignored
		0,											// No Alpha Buffer
		0,											// Shift Bit Ignored
		0,											// No Accumulation Buffer
		0, 0, 0, 0,									// Accumulation Bits Ignored
		16,											// 16Bit Z-Buffer (Depth Buffer)  
		0,											// No Stencil Buffer
		0,											// No Auxiliary Buffer
		PFD_MAIN_PLANE,								// Main Drawing Layer
		0,											// Reserved
		0, 0, 0										// Layer Masks Ignored
	};
	
	if (!(hDC=GetDC(hWnd)))							// Did We Get A Device Context?
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Can't Create A GL Device Context.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	if (!(PixelFormat=ChoosePixelFormat(hDC,&pfd)))	// Did Windows Find A Matching Pixel Format?
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Can't Find A Suitable PixelFormat.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	if(!SetPixelFormat(hDC,PixelFormat,&pfd))		// Are We Able To Set The Pixel Format?
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Can't Set The PixelFormat.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	if (!(hRC=wglCreateContext(hDC)))				// Are We Able To Get A Rendering Context?
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Can't Create A GL Rendering Context.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	if(!wglMakeCurrent(hDC,hRC))					// Try To Activate The Rendering Context
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Can't Activate The GL Rendering Context.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	ShowWindow(hWnd,SW_SHOW);						// Show The Window
	SetForegroundWindow(hWnd);						// Slightly Higher Priority
	SetFocus(hWnd);									// Sets Keyboard Focus To The Window
	ReSizeGLScene(width, height);					// Set Up Our Perspective GL Screen

	if (!InitGL())									// Initialize Our Newly Created GL Window
	{
		KillGLWindow();								// Reset The Display
		MessageBox(NULL,"Initialization Failed.","ERROR",MB_OK|MB_ICONEXCLAMATION);
		return FALSE;								// Return FALSE
	}

	return TRUE;									// Success
}

LRESULT CALLBACK WndProc(	HWND	hWnd,			// Handle For This Window
							UINT	uMsg,			// Message For This Window
							WPARAM	wParam,			// Additional Message Information
							LPARAM	lParam)			// Additional Message Information
{
	switch (uMsg)									// Check For Windows Messages
	{
		case WM_ACTIVATE:							// Watch For Window Activate Message
		{
			if (!HIWORD(wParam))					// Check Minimization State
			{
				active=TRUE;						// Program Is Active
			}
			else
			{
				active=FALSE;						// Program Is No Longer Active
			}

			return 0;								// Return To The Message Loop
		}

		case WM_SYSCOMMAND:							// Intercept System Commands
		{
			switch (wParam)							// Check System Calls
			{
				case SC_SCREENSAVE:					// Screensaver Trying To Start?
				case SC_MONITORPOWER:				// Monitor Trying To Enter Powersave?
				return 0;							// Prevent From Happening
			}
			break;									// Exit
		}

		case WM_CLOSE:								// Did We Receive A Close Message?
		{
			PostQuitMessage(0);						// Send A Quit Message
			return 0;								// Jump Back
		}

		case WM_KEYDOWN:							// Is A Key Being Held Down?
		{
			keys[wParam] = TRUE;					// If So, Mark It As TRUE
			return 0;								// Jump Back
		}

		case WM_KEYUP:								// Has A Key Been Released?
		{
			keys[wParam] = FALSE;					// If So, Mark It As FALSE
			return 0;								// Jump Back
		}

		case WM_SIZE:								// Resize The OpenGL Window
		{
			ReSizeGLScene(LOWORD(lParam),HIWORD(lParam));  // LoWord=Width, HiWord=Height
			return 0;								// Jump Back
		}
	}

	// Pass All Unhandled Messages To DefWindowProc
	return DefWindowProc(hWnd,uMsg,wParam,lParam);
}

int WINAPI WinMain(	HINSTANCE	hInstance,			// Instance
					HINSTANCE	hPrevInstance,		// Previous Instance
					LPSTR		lpCmdLine,			// Command Line Parameters
					int			nCmdShow)			// Window Show State
{
	MSG		msg;									// Windows Message Structure
	BOOL	done=FALSE;								// Bool Variable To Exit Loop

	// Ask The User Which Screen Mode They Prefer
	if (MessageBox(NULL,"Would You Like To Run In Fullscreen Mode?", "Start FullScreen?",MB_YESNO|MB_ICONQUESTION)==IDNO)
	{
		fullscreen=FALSE;							// Windowed Mode
	}

	// Create Our OpenGL Window
	if (!CreateGLWindow("RTA bridge maintenance",640,480,16,fullscreen))
	{
		return 0;									// Quit If Window Was Not Created
	}

	while(!done)									// Loop That Runs While done=FALSE
	{
		if (PeekMessage(&msg,NULL,0,0,PM_REMOVE))	// Is There A Message Waiting?
		{
			if (msg.message==WM_QUIT)				// Have We Received A Quit Message?
			{
				done=TRUE;							// If So done=TRUE
			}
			else									// If Not, Deal With Window Messages
			{
				TranslateMessage(&msg);				// Translate The Message
				DispatchMessage(&msg);				// Dispatch The Message
			}
		}
		else										// If There Are No Messages
		{
			// Draw The Scene.  Watch For ESC Key And Quit Messages From DrawGLScene()
			if ((active && !DrawGLScene()) || keys[VK_ESCAPE])	// Active?  Was There A Quit Received?			
			{
				done=TRUE;							// ESC or DrawGLScene Signalled A Quit
			}
			else									// Not Time To Quit, Update Screen
			{
				SwapBuffers(hDC);					// Swap Buffers (Double Buffering)
				if (keys['B'] && !bp)
				{
					bp=TRUE;
					blend=!blend;
					if (!blend)
					{
						glDisable(GL_BLEND);
						glEnable(GL_DEPTH_TEST);
					}
					else
					{
						glEnable(GL_BLEND);
						glDisable(GL_DEPTH_TEST);
					}
				}
				if (!keys['B'])
				{
					bp=FALSE;
				}

				if (keys['F'] && !fp)
				{
					fp=TRUE;
					filter+=1;
					if (filter>2)
					{
						filter=0;
					}
				}
				if (!keys['F'])
				{
					fp=FALSE;
				}

				if (keys[VK_PRIOR])
				{
					z-=0.02f;
				}

				if (keys[VK_NEXT])
				{
					z+=0.02f;
				}

				if (keys[VK_UP])
				{

					xpos -= (float)sin(heading*piover180) * 0.001f;
					zpos -= (float)cos(heading*piover180) * 0.001f;
					if (walkbiasangle >= 359.0f)
					{
						walkbiasangle = 0.0f;
					}
					else
					{
						walkbiasangle+= 10;
					}
					walkbias = (float)sin(walkbiasangle * piover180)/20.0f;
				}

				if (keys[VK_DOWN])
				{
					xpos += (float)sin(heading*piover180) * 0.001f;
					zpos += (float)cos(heading*piover180) * 0.001f;
					if (walkbiasangle <= 1.0f)
					{
						walkbiasangle = 359.0f;
					}
					else
					{
						walkbiasangle-= 10;
					}
					walkbias = (float)sin(walkbiasangle * piover180)/20.0f;
				}

				if (keys[VK_RIGHT])
				{
					//heading -= 0.3f;
					yrot -= 0.05f;
				}

				if (keys[VK_LEFT])
				{
					//heading += 0.3f;	
					yrot += 0.05f;	
				}

				if (keys[VK_PRIOR])
				{
					lookupdown-= 1.0f;
				}

				if (keys[VK_NEXT])
				{
					lookupdown+= 1.0f;
				}

				if (keys[VK_F1])						// Is F1 Being Pressed?
				{
					keys[VK_F1]=FALSE;					// If So Make Key FALSE
					KillGLWindow();						// Kill Our Current Window
					fullscreen=!fullscreen;				// Toggle Fullscreen / Windowed Mode
					// Recreate Our OpenGL Window
					if (!CreateGLWindow("RTA bridge maintenance",640,480,16,fullscreen))
					{
						return 0;						// Quit If Window Was Not Created
					}
				}
				if (keys[VK_NUMPAD4])
				{
					float yrotrad;
					yrotrad = (yrot / 180 * 3.141592654f);
					xpos += float(cos(yrotrad)) * 0.01;
					zpos += float(sin(yrotrad)) * 0.01;
				}
				if (keys[VK_NUMPAD6])
				{
					float yrotrad;
					yrotrad = (yrot / 180 * 3.141592654f);
					xpos -= float(cos(yrotrad)) * 0.01;
					zpos -= float(sin(yrotrad)) * 0.01;
				}
				if (keys[VK_NUMPAD2])
				{
					float yrotrad;
					yrotrad = (yrot / 180 * 3.141592654f);
					zpos += float(cos(yrotrad)) * 0.01;
					xpos += float(sin(yrotrad)) * 0.01;
				}
				if (keys[VK_NUMPAD8])
				{
					float yrotrad;
					yrotrad = (yrot / 180 * 3.141592654f);
					zpos -= float(cos(yrotrad)) * 0.01;
					xpos -= float(sin(yrotrad)) * 0.01;
				}
				if (keys[VK_NUMPAD7])
				{
					ypos += 0.01f;
				}
				if (keys[VK_NUMPAD1])
				{
					ypos -= 0.01f;
				}
			}
		}
	}

	// Shutdown
	KillGLWindow();										// Kill The Window
	return (msg.wParam);								// Exit The Program
}
GLvoid BuildFont(GLvoid)								// Build Our Bitmap Font
{
	HFONT	font;										// Windows Font ID
	HFONT	oldfont;									// Used For Good House Keeping

	base = glGenLists(96);								// Storage For 96 Characters

	font = CreateFont(	-24,							// Height Of Font
						0,								// Width Of Font
						0,								// Angle Of Escapement
						0,								// Orientation Angle
						FW_BOLD,						// Font Weight
						FALSE,							// Italic
						FALSE,							// Underline
						FALSE,							// Strikeout
						ANSI_CHARSET,					// Character Set Identifier
						OUT_TT_PRECIS,					// Output Precision
						CLIP_DEFAULT_PRECIS,			// Clipping Precision
						ANTIALIASED_QUALITY,			// Output Quality
						FF_DONTCARE|DEFAULT_PITCH,		// Family And Pitch
						"Courier New");					// Font Name

	oldfont = (HFONT)SelectObject(hDC, font);           // Selects The Font We Want
	wglUseFontBitmaps(hDC, 32, 96, base);				// Builds 96 Characters Starting At Character 32
	SelectObject(hDC, oldfont);							// Selects The Font We Want
	DeleteObject(font);									// Delete The Font
}
GLvoid KillFont(GLvoid)									// Delete The Font List
{
	glDeleteLists(base, 96);							// Delete All 96 Characters
}
GLvoid glPrint(const char *fmt, ...)					// Custom GL "Print" Routine
{
	char		text[256];								// Holds Our String
	va_list		ap;										// Pointer To List Of Arguments

	if (fmt == NULL)									// If There's No Text
		return;											// Do Nothing

	va_start(ap, fmt);									// Parses The String For Variables
	    vsprintf(text, fmt, ap);						// And Converts Symbols To Actual Numbers
	va_end(ap);											// Results Are Stored In Text

	glPushAttrib(GL_LIST_BIT);							// Pushes The Display List Bits
	glListBase(base - 32);								// Sets The Base Character to 32
	glCallLists(strlen(text), GL_UNSIGNED_BYTE, text);	// Draws The Display List Text
	glPopAttrib();										// Pops The Display List Bits
}