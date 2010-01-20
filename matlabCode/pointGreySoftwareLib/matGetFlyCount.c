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
#include <pgrflycapture.h>
#include <pgrerror.h>



/* 
 * Enumerate bus camera on firewire bus
 */


int CountCams(double *dCameraCount)
{

    FlyCaptureError error;
         
    int nCameraCount;
    
    error = flycaptureBusCameraCount(
                            &nCameraCount );
                            
    if ( error != FLYCAPTURE_OK )
    {
          printf( "\nflycaBusCameraCount: %s\n", flycaptureErrorToString( error ) );
	  return 0;
    }                              
                            
    *dCameraCount = nCameraCount;
    return 1;
         
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dCameraCount;
   
  /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
 
    
  /* Assign pointers to output. */
  dCameraCount = mxGetPr(plhs[0]);
  
  /* Call the bridging function to do the camera count */
  if( !CountCams(dCameraCount) )
  {
     mexErrMsgTxt( "matGetFlyCount failed !!" );
  }
}


/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matGetFlyCount.c
 */