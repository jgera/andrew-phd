#ifdef _CH_
#pragma package <opencv>
#endif


#include "stdafx.h"
#include "cv.h"
#include "highgui.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <time.h>
#include <ctype.h>

#ifdef _EiC
#define WIN32
#endif

static CvMemStorage* storage = 0;


void detect_and_draw( IplImage* image );
void histogramCreation(IplImage* image);

//variables
int i = 0;
int j = 0;
int k = 0;
int r = 0;
int g = 0;
int b = 0;

int height,width,step,channels;   
int stepr, channelsr;   
int temp=0;	   
uchar *data,*datar;   

IplImage* image = 0;
IplImage* result = 0;

const char* cascade_name =
    "haarcascade_frontalface_alt.xml";
/*    "haarcascade_profileface.xml";*/

void on_mouse( int event, int x, int y, int flags, void* param )
{
    if( !image )
        return;
    if( event == CV_EVENT_LBUTTONDOWN )
    {
        //CvPoint pt = cvPoint(x,y);
		//Test stub	
		/*IplImage* grayImage = cvCreateImage(cvSize(image->width,image->height), 
		IPL_DEPTH_8U, 1);
		cvCvtColor(image, grayImage, CV_BGR2GRAY);
		cvShowImage( "testWin", grayImage);*/
		//CvPoint pt = cvPoint(x,y);
		//r = data[y*step+x*channels+2];
		//g = data[y*step+x*channels+1];
		//b = data[y*step+x*channels];
		for(i=0;i < (height);i++) for(j=0;j <(width);j++)   
		{
			if(((data[i*step+j*channels+2]) < (data[y*step+x*channels+2]))   
			&& ((data[i*step+j*channels+1]) < (data[y*step+x*channels+1]))
			&& ((data[i*step+j*channels]) < (data[y*step+x*channels])))   
			datar[i*stepr+j*channelsr]=255;   
			else  
				datar[i*stepr+j*channelsr]=0;   
		}
		cvShowImage("result",result);		
    }
}
int main( int argc, char** argv )
{
	//
	//Load image file and create window
	char* filename = argc >= 2 ? argv[1] : (char*)"labTest.JPG";
	image = cvLoadImage(filename,1);
	result = cvCreateImage( cvGetSize(image), 8, 1 );
	cvNamedWindow( "image", 1 );
	cvNamedWindow( "result", 1);	
	//

	height = image->height;
	width = image->width;
	step = image->widthStep;
	channels = image->nChannels;   
	data = (uchar *)image->imageData;     
  
	stepr=result->widthStep;   
	channelsr=result->nChannels;   
	datar = (uchar *)result->imageData; 

	//for(i=0;i < (height);i++) for(j=0;j <(width);j++)   
	//{
	//	if(((data[i*step+j*channels+2]) > (29+data[i*step+j*channels]))   
	//	&& ((data[i*step+j*channels+2]) > (29+data[i*step+j*channels+1])))   
	//	datar[i*stepr+j*channelsr]=255;   
	//	else  
	//		datar[i*stepr+j*channelsr]=0;   
	//}
	//Create a mouse listen
	cvSetMouseCallback( "image", on_mouse, 0 );
	cvShowImage("image",image);   
	//cvShowImage("result",result);
	cvWaitKey(0);
	cvDestroyWindow("image");   
	cvDestroyWindow("result");
	return(0);
}

