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
 * Retrieve camera gain
 */
int GetCamGain(double dContext, double* pdGain )
{
    FlyCaptureError error;
    FlyCaptureContext flyContext = (long)dContext;
    long lValueA,lValueB;
    bool bAuto;
    
    error = flycaptureGetCameraProperty(
                     flyContext,
                     FLYCAPTURE_GAIN,
                     &lValueA,
                     &lValueB,
                     &bAuto         );
    if ( error != FLYCAPTURE_OK )
    {
        printf( "\nflycaGetCameraProperty(GAIN): %s\n", flycaptureErrorToString( error ) );
	return 0;
    }
   
   //*pdGain = (double)lValueA;   
   *pdGain = (double)lValueB;   
   return 1;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dGain,*dContext;
   
   
   /* Check for proper number of arguments. */
  if(nrhs != 1) 
  {
    mexErrMsgTxt("One input required.");
  } else if(nlhs > 1) 
  {
    mexErrMsgTxt("Too many output arguments");
  }
   
   /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    
  /* Assign pointers to output and inputs. */
  
  dGain = mxGetPr(plhs[0]);
  dContext = mxGetPr(prhs[0]);
  
  /* Call the bridging function to get the camera gain */
  if( !GetCamGain(*dContext, dGain) )
  {
      mexErrMsgTxt( "matGetFlyGain failed !!" );
  }
}

/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matGetFlyGain.c
 */