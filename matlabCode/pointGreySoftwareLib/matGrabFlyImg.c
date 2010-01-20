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
#include <malloc.h>
#include <string.h> 

/* 
 * Grab and color process an image from a flycapture camera
 */
int GrabImg(double* dContext, unsigned char* pImageBufferBGR24)
{
    FlyCaptureVideoMode videoMode;   
    FlyCaptureError error;
    FlyCaptureContext context = (long)*dContext;
    
    FlyCaptureImage		 flyImage;
    int iRows = 0;
    int iCols = 0;
    int iRowInc = 0;
    char test[100];
    
    error=flycaptureGrabImage2( context, &flyImage );
       
    if ( error != FLYCAPTURE_OK )
    {
        printf( "\nflycaptureGrabImage2: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }
    
    error = flycaptureStippledToBGR24( context, &flyImage, pImageBufferBGR24 );
    if ( error != FLYCAPTURE_OK )
    {
        printf( "\flycaptureConvertToBGR24: %s\n", flycaptureErrorToString( error ) );
        return 0;
    }
    return 1;         
}


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *dContext;
   unsigned char *Image_buf = NULL;
   const int dims[] = {1,640*480*3};
   int NDIMS = 2;
   unsigned char *start_of_pr;
   int bytes_to_copy;   

    
   /* Check for proper number of arguments. */
  if(nrhs != 1) 
  {
    mexErrMsgTxt("One input required.");
  } 
  else if(nlhs > 1) 
  {
    mexErrMsgTxt("Too many output arguments");
  }
  
  /* Allocate memory for input and output strings. */
  Image_buf = mxCalloc(640*480*3, sizeof(char));
   
  
  /* Assign pointers to output and inputs. */
  dContext = mxGetPr(prhs[0]);
  
  /* Call The C subroutine */
  if( !GrabImg(dContext,Image_buf) )
  {
     mexErrMsgTxt( "matGrabFlyImg failed !!" );
  }
    
  /* Create a 2-by-2 array of unsigned 16-bit integers. */
  plhs[0] = mxCreateNumericArray( NDIMS,
				  dims,
				  mxUINT8_CLASS,mxREAL );
      
  /* Populate the real part of the created array. */
  start_of_pr = (unsigned char *) mxGetPr(plhs[0]);
  bytes_to_copy = 640*480*3 * mxGetElementSize(plhs[0]);
  memcpy(start_of_pr,Image_buf,bytes_to_copy);


}



/*
 * To Compile use the following command
 * mex -g -f "pgrmex.bat" matGrabFlyImg.c
 */