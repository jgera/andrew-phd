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
#include <iostream.h>
#include <pgrflycapture.h>
#include <pgrerror.h>

/* 
 * stop camera and discard context
 */
int StopCam(double *dContext)
{
    FlyCaptureError error;
    FlyCaptureContext context = (long)*dContext;
              
    if (*dContext ==-1)
    {
        printf("\nWrong camera number was entered during InitCam call");
        return;
    }
    
    error=flycaptureStop(context);
    if ( error != FLYCAPTURE_OK )
    {
        printf( "flycaptureStop: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }


    error = flycaptureDestroyContext(context);
    if ( error != FLYCAPTURE_OK )
    {
        printf( "flycaptureDestroyContext: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }
    
    printf("CAMERA STOPPED\n");
    
    return 1;     
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dContext;
          
  /* Assign pointers to input. */
  dContext = mxGetPr(prhs[0]);
    
  /* Call the bridging function to stop camera */
  if( !StopCam(dContext) )
  {
     mexErrMsgTxt( "matStopFly failed !!" );
  }
}

/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matStopFly.c
 */