
Copyright (c) 2003 Point Grey Research, Inc. All Rights Reserved.
This software is the confidential and proprietary information of Point
Grey Research, Inc. ("Confidential Information").  You shall not
disclose such Confidential Information and shall use it only in
accordance with the terms of the license agreement you entered into
with PGR.

PGR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE
SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT. PGR SHALL NOT BE LIABLE FOR ANY DAMAGES
SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING
THIS SOFTWARE OR ITS DERIVATIVES.

This folder contains a collection of source and project files which will build a set of mex dll files 
that allows a user to issue PGRFlyCapture API calls within a Matlab environment.

The files contain here are as follows :

   C Source files :
	matGetFlyCount.c - mex wrapper file for flycaptureBusCameraCount
	matGetFlyGain.c  - mex wrapper file for calling flycaptureGetCameraProperty to get camera gain
	matGetFlyShutterSpeed.c  - mex wrapper file for calling flycaptureGetCameraProperty to get camera shutter speed
	matGrabFlyImg.c - mex wrapper file for capturing an image via flycaptureGrabImage2
	matInitFly.c - mex wrapper file for initializing a PGR flycapture camera
	matSetFlyGain.c  - mex wrapper file for calling flycaptureSetCameraProperty to set camera gain
	matSetFlyShutterSpeed.c  - mex wrapper file for calling flycaptureSetCameraProperty to set camera shutter speed
	matSetFlyTrigger.c - mex wrapper file for flycaptureSetCameraTrigger
	matStopFly.c - mex wrapper file for closing a PGR flycapture camera
	
   DevStudio project file :
	matlab_pgrflycapture.dsp - this project will compiles all the above C source files using 
		Matlab mex script.  This project assumes that you already have Matlab installed in
		your system and that Matlab bin directory is included in the DevStudio exe search 
		path (add it by going to Tools\Options\Directories tab in DevStudio).
		As part of the overall build process, it will install the build dlls as well as a copy
		of pgrflycapture.dll in the matSrc directory.  These are all done under the post-build
		tab in the project settings.  Be sure to modify from where it should be copying the 
		pgrflycapture.dll to reflect where it is installed in your system
		

   MEX options file :
	pgrmex.bat - this file contains the necessary options for mex so that it knows where to find
		the PGRFlyCapture library during compilation.  Be sure to modify the Matlab and 
		pgrflycapture location in this file to reflect where they are installed in your system

   Matlab grab program
   	matSrc/pgrgrabImg.m - this contains an example matlab file that uses some of the flycapture 
		MEX dll interfaces to grab images from all PGR FireFly or DragonFly cameras on the bus.
		Note that this will require all the MEX dlls and the pgrflycapture.dll in its direct
		search path in order for it to work properly.  These will be installed automatically
		if you have built via the DevStudio project file.
	