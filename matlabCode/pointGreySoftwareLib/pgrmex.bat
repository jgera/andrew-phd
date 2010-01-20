rem
rem This software is the confidential and proprietary information of Point
rem Grey Research, Inc. ("Confidential Information").  You shall not
rem disclose such Confidential Information and shall use it only in
rem accordance with the terms of the license agreement you entered into
rem with PGR.
rem 
rem PGR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE
rem SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
rem IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
rem PURPOSE, OR NON-INFRINGEMENT. PGR SHALL NOT BE LIABLE FOR ANY DAMAGES
rem SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING
rem THIS SOFTWARE OR ITS DERIVATIVES.
rem OF USING, MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
rem

rem 
rem Point Grey Research would like to thank and acknowledge Ndimi Bodika
rem of De Beers Group for his original contribution to this code.
rem

@echo off
rem
rem    Compile and link options used for building MEX-files
rem    using the Microsoft Visual C++ compiler version 6.0 
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************

rem set MATLAB=C:\MATLAB6p5
set MATLAB=C:\MATLAB\R2009a
rem set MSVCDir=%MSVCDir%
rem set MSDevDir=%MSVCDir%\..\Common\msdev98
set FLYCAPDir=C:\PROGRAM FILES\POINT GREY RESEARCH\PGR FLYCAPTURE
rem set FLYCAPDir=P:\pgrflycapture\release\1.4.0.018

rem set PATH=%MSVCDir%\BIN;%MSDevDir%\bin;%PATH%
rem set INCLUDE=%MSVCDir%\INCLUDE;%MSVCDir%\MFC\INCLUDE;%FLYCAPDir%\INCLUDE;%MSVCDir%\ATL\INCLUDE;%INCLUDE%
rem set LIB=%MSVCDir%\LIB;%MSVCDir%\MFC\LIB;C:\PROGRAM FILES\POINT GREY RESEARCH\PGR FLYCAPTURE\LIB;%LIB%

set LIB=%FLYCAPDir%\LIB;%LIB%
set INCLUDE=%FLYCAPDir%\INCLUDE;%INCLUDE%

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=lcc
set COMPFLAGS=/c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo /MD
set OPTIMFLAGS=/O2 /Oy- /DNDEBUG
set DEBUGFLAGS=/Zi /Fd"%OUTDIR%%MEX_NAME%%MEX_EXT%.pdb"
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win32\microsoft\;%FLYCAPDir%\LIB
rem set LIBLOC=%MATLAB%\extern\lib\win32\microsoft\
set LINKER=link
set LINKFLAGS=/dll /export:%ENTRYPOINT% /MAP /LIBPATH:"%LIBLOC%" libmx.lib libmex.lib libmatlb.lib libmat.lib pgrflycapture.lib /implib:%LIB_NAME%.x
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%.dll"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%mexversion.res"
set RC_LINKER=

set POSTLINK_CMDS=del "%OUTDIR%%MEX_NAME%.map"
set POSTLINK_CMDS1=del %LIB_NAME%.x
