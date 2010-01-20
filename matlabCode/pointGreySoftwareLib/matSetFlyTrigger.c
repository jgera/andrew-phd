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
 * Set camera trigger mode
*/
int SetTrigger(double dContext, double TrigOn)
{
    FlyCaptureError error;
    FlyCaptureContext context = (long)dContext;
    
    unsigned char ucOnOff = 0;
              
    if (dContext ==-1)
    {
        printf("\nWrong camera number was entered during InitCam call\n");
        return 0;
    }
    
    ucOnOff = ( TrigOn ? 1 : 0 );
    
    error=flycaptureSetCameraTrigger( context,
		                      ucOnOff,
				      0,
				      0);    
              
    if (dContext ==-1)
    {
        printf( "\nflycaptureSetCameraTrigger: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }
    printf("CAMERA TRIGGERED: %i\n",ucOnOff);
    
    return 1;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dContext;
   double *TrigOn;
          
  /* Assign pointers to input. */
  dContext = mxGetPr(prhs[0]);
  TrigOn = mxGetPr(prhs[1]);
    
  /* Call the bridging function to set camera trigger */
  if( !SetTrigger(*dContext,*TrigOn) )
  {
     mexErrMsgTxt( "matSetFlyTrigger failed !!" );
  }
}

/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matSetFlyTrigger.c
 */