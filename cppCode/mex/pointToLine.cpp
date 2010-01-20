#include <stdio.h>
#include <math.h>
#include "mex.h"
//AB forms the line, C is the point in space
typedef struct point {
	double x,y,z;
} point

int linePointDist(point A, point B, point C, double distance)
{
	double dist = ((B-A)^(C-A)) / sqrt((B-A)*(B-A));    
    return 0;
	return distance;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
              
{
   double *pointA, *pointB, *pointC, *distance;
   
   
   /* Check for proper number of arguments. */
  if(nrhs != 3) 
  {
    mexErrMsgTxt("Need 3 inputs.");
  } else if(nlhs > 3) 
  {
    mexErrMsgTxt("Too many output arguments");
  }
  if( mxGetM(prhs[0]) != 1 || mxGetM(prhs[1]) != 1 )
      mexErrMsgTxt("Both inputs must be row vectors.");
  
  //get pointers to the inputs
  pointA = mxGetPr(prhs[0]);
  pointB = mxGetPr(prhs[1]);
  pointC = mxGetPr(prhs[2]);
  	  
  /* Create matrix for the return argument. 1x3 matrix */
  plhs[0] = mxCreateDoubleMatrix(1,3,mxREAL);
  //Associate the output with the matrix
  distance = mxGetPr(plhs[0]);
    
  /* Call the C subroutine */
  linePointDist(pointA, pointB, pointC, distance);
	  return;
}