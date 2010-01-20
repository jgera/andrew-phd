/*
 * This software is the confidential and proprietary information of Point
 * Grey Research, Inc. ("Confidential Information").  You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with PGR.
 * 
 * PGR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE
 * SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE, OR NON-INFRINGEMENT. PGR SHALL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING
 * THIS SOFTWARE OR ITS DERIVATIVES.
 * OF USING, MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
 */

/* 
 * Point Grey Research would like to thank and acknowledge Ndimi Bodika
 * of De Beers Group for his original contribution to this code.
 */

#include "mex.h"
//#include <iostream.h>
#include <pgrflycapture.h>
#include <pgrerror.h>

/* 
 * Initialise Cameras on Firewire bus
 */
int InitCam(double *dContext, int CamNum)
{
    FlyCaptureError error;
    FlyCaptureContext context;
    int nCameraCount;
    
    error = flycaptureBusCameraCount(
                            &nCameraCount );
    if((CamNum>nCameraCount)|(CamNum<=0))
    {
        //printf("\nCamera Number entered exceed(or <= zero) numbers of camera found on bus: %d",nCameraCount);
        *dContext = -1;
        return 0;
    }
    
    CamNum = CamNum - 1;
    
    error = flycaptureCreateContext( &context );
    if( error != FLYCAPTURE_OK )
    {
        //printf( "flycaptureCreateContext: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }
    
    *dContext = (double)((long)context);
    
    error = flycaptureInitialize( context, CamNum );
    if( error != FLYCAPTURE_OK )
    {
        //printf( "flycaptureInitialize: %s\n", flycaptureErrorToString( error ) );
	return 0;
    }    
  
    error = flycaptureStart(
	context,
	FLYCAPTURE_VIDEOMODE_640x480Y8,
	FLYCAPTURE_FRAMERATE_30 );
	
    if( error != FLYCAPTURE_OK )
    {
        //printf( "flycaptureStart: %s\n", flycaptureErrorToString( error ) );
	return 0;
    }    
	
    //printf("CAMERA %d ON BUS INITIALISED AND STARTED\n",CamNum+1); 
    return 1;	        
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dContext;
   double *CamNum;
   
   /* Check for proper number of arguments. */
  if(nrhs != 1) 
  {
    mexErrMsgTxt("One input required.");
  } 
  else if(nlhs > 1) 
  {
    mexErrMsgTxt("Too many output arguments");
  }
   
   /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    
  /* Assign pointers to output and inputs. */
  dContext = mxGetPr(plhs[0]);
  CamNum = mxGetPr(prhs[0]);
  
  /* Call the bridging function to initialize the camera */
  if( !InitCam(dContext,(int)*CamNum) )
  {
      mexErrMsgTxt( "matInitFly failed !!" );
  }
}



/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matInitFly.c
 */