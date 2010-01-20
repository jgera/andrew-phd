# Microsoft Developer Studio Project File - Name="matlab_pgrflycapture" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=matlab_pgrflycapture - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "matlab_pgrflycapture.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "matlab_pgrflycapture.mak" CFG="matlab_pgrflycapture - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "matlab_pgrflycapture - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "matlab_pgrflycapture - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x1009 /d "NDEBUG"
# ADD RSC /l 0x1009 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# Begin Special Build Tool
OutDir=.\Release
SOURCE="$(InputPath)"
PostBuild_Cmds=xcopy /f/y $(outdir)\*.dll matSrc	xcopy /f/y P:\pgrflycapture\release\1.4.0.018\bin\pgrflycapture.dll matSrc
# End Special Build Tool

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x1009 /d "_DEBUG"
# ADD RSC /l 0x1009 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# Begin Special Build Tool
OutDir=.\Debug
SOURCE="$(InputPath)"
PostBuild_Cmds=xcopy /f/y $(outdir)\*.dll matSrc	xcopy /f/y P:\pgrflycapture\release\1.4.0.018\bin\pgrflycapture.dll matSrc
# End Special Build Tool

!ENDIF 

# Begin Target

# Name "matlab_pgrflycapture - Win32 Release"
# Name "matlab_pgrflycapture - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\matGetFlyCount.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matGetFlyCount.c
InputName=matGetFlyCount

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matGetFlyCount.c
InputName=matGetFlyCount

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matGetFlyGain.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matGetFlyGain.c
InputName=matGetFlyGain

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matGetFlyGain.c
InputName=matGetFlyGain

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matGetFlyShutterSpeed.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matGetFlyShutterSpeed.c
InputName=matGetFlyShutterSpeed

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matGetFlyShutterSpeed.c
InputName=matGetFlyShutterSpeed

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matGrabFlyImg.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matGrabFlyImg.c
InputName=matGrabFlyImg

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matGrabFlyImg.c
InputName=matGrabFlyImg

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matInitFly.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matInitFly.c
InputName=matInitFly

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matInitFly.c
InputName=matInitFly

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matSetFlyGain.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matSetFlyGain.c
InputName=matSetFlyGain

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matSetFlyGain.c
InputName=matSetFlyGain

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matSetFlyShutterSpeed.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matSetFlyShutterSpeed.c
InputName=matSetFlyShutterSpeed

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matSetFlyShutterSpeed.c
InputName=matSetFlyShutterSpeed

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matSetFlyTrigger.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matSetFlyTrigger.c
InputName=matSetFlyTrigger

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matSetFlyTrigger.c
InputName=matSetFlyTrigger

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\matStopFly.c

!IF  "$(CFG)" == "matlab_pgrflycapture - Win32 Release"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Release
InputPath=.\matStopFly.c
InputName=matStopFly

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ELSEIF  "$(CFG)" == "matlab_pgrflycapture - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
OutDir=.\Debug
InputPath=.\matStopFly.c
InputName=matStopFly

"$(OutDir)/$(InputName).dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	mex -g -f "pgrmex.bat" -outdir $(OutDir) $(InputName).c

# End Custom Build

!ENDIF 

# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
