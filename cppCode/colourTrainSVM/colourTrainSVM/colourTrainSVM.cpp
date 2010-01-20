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
#include <errno.h>
#include <svm.h>
#include "svm.cpp"

#ifdef _EiC
#define WIN32
#endif

void predictionAndDrawing( IplImage* img );

struct svm_problem prob;
struct svm_parameter param;
struct svm_model *model;
struct svm_node *x_space;
int flag;
//variables
IplImage* image = 0;
IplImage* result = 0;
IplImage* class1 = 0;
IplImage* class2 = 0;


int main( int argc, char** argv )
{	
   //load the images
	char* filename1 = argc >= 2 ? argv[1] : (char*)"wallPhoto.jpg";
	char* filename2 = argc >= 2 ? argv[1] : (char*)"class1.jpg";
	char* filename3 = argc >= 2 ? argv[1] : (char*)"class2.jpg";
	image = cvLoadImage(filename1,1);				
	result = cvLoadImage(filename1,1);
	class1 = cvLoadImage(filename2,1);
	class2 = cvLoadImage(filename3,1);
	cvNamedWindow( "image", 1 );
	cvNamedWindow( "result", 1 );

	//Build the training datafile assume class1 and class2 image have same attributes
	int height = class1->height;
	int width = class1->width;
	int step = class1->widthStep;
	int channels = class1->nChannels; 
	uchar *dataClass1,*dataClass2;
	dataClass1 = (uchar *)class1->imageData;
	dataClass2 = (uchar *)class2->imageData;

	//Construct the svm problem structure
	
	int element = height*width*8;
	prob.l = height*width*2; //Number of training data 50*20*2
	prob.y = Malloc(double,prob.l);
	prob.x = Malloc(struct svm_node *,prob.l);
	x_space = Malloc(struct svm_node,2000);
	//double probYArray[2000];
	//prob.y = probYArray; //create an array for prob.y
	//Put class1 data into svm_model
	int counter = 0; 
	for(int i = 0; i < height*width; i++)//class 1
	{		
		prob.y[i] = 1;
		prob.x[i] = &x_space[counter];
		for (int j = 0; j<4; j++)
		{
			int x = i/width; //X is row reference with 50 elements each row
			int y;
			if(i < width)
			{
				y = i;
			}
			else
			{
				y = i%width; //Remainder, indicate the element position in row
			}
			if (j < 3)
			{
				x_space[counter].index = j+1;
				//x_space[counter].value = (double)dataClass1[x*step+y*channels+j];
				x_space[counter].value = 2;
				counter++;
				//prob.x[i][j].index = j+1;
				//prob.x[i][j].value = (double)dataClass1[x*step+y*channels+j];				
			}
			else
			{
				x_space[counter].index = -1;
				counter++;
				//prob.x[i][j].index = -1;
			}			
		}		
	}

	//for(int i = height*width; i < height*width*2; i++)//class 2
	//{		
	//	prob.y[i] = -1;		
	//	for (int j = 0; j<4; j++)
	//	{
	//		int x = i/width; //X is row reference with 50 elements each row
	//		int y;
	//		if(i < width)
	//		{
	//			y = i;
	//		}
	//		else
	//		{
	//			y = i%width; //Remainder, indicate the element position in row
	//		}
	//		if (j < 3)
	//		{
	//			prob.x[i][j].index = j+1;
	//			//prob.x[i][j].value = (double)dataClass2[x*step+y*channels+j];				
	//		}
	//		else
	//		{
	//			prob.x[i][j].index = -1;
	//		}			
	//	}		
	//}
	// Set up the SVM paramaters, leaving as default	
	//model = svm_train(&prob,&param);	
	//svm_save_model("dataModel",model);
	
	//Build the video capture
	CvCapture* capture = 0;
    IplImage *frame, *frame_copy = 0;
	const char* input_name;
	input_name = argc > 1 ? argv[1] : 0;
	if( !input_name || (isdigit(input_name[0]) && input_name[1] == '\0') )
        capture = cvCaptureFromCAM( !input_name ? 0 : input_name[0] - '0' );
    else
        capture = cvCaptureFromAVI( input_name );

	if( capture)
    {
        for(;;)
        {
            if( !cvGrabFrame( capture ))
                break;
            frame = cvRetrieveFrame( capture );
            if( !frame )
                break;
            if( !frame_copy )
                frame_copy = cvCreateImage( cvSize(frame->width,frame->height),
                                            IPL_DEPTH_8U, frame->nChannels );
            if( frame->origin == IPL_ORIGIN_TL )
                cvCopy( frame, frame_copy, 0 );
            else
                cvFlip( frame, frame_copy, 0 );
            
            predictionAndDrawing( frame_copy );
			//histogramCreation(frame_copy);
			flag = 1;

            if( cvWaitKey( 10 ) >= 0 )
                break;
        }
        cvReleaseImage( &frame_copy );
        cvReleaseCapture( &capture );
    }
		
	cvWaitKey(0);
	return 0;
}

void predictionAndDrawing( IplImage* img )
{
	//cvShowImage("image",img);
	//Build the testing dataset
	//uchar *testingData;
	//int height = img->height;
	//int width = img->width;
	//int step = img->widthStep;
	//int channels = img->nChannels;
	//double r,g,b;
	//testingData = (uchar *)img->imageData;
	//FILE * pFile;
	//pFile = fopen ("testingData","wb");
	////Loop that runs through all the pixels in the image and saves it to file
	//for(int i=0;i < (height);i++) for(int j=0;j <(width);j++)   
	//	{
	//		r = testingData[i*step+j*channels+2]/255;			
	//		g = testingData[i*step+j*channels+1]/255;
	//		b = testingData[i*step+j*channels]/255;
	//		fprintf (pFile, "1 1:%g 2:%g 3:%g \n",r,g,b); 		
	//	}	
	//fclose (pFile);
	
	//scale the training data	
	//system("C:\svm-scale testingData>testingDataScaled");
	//Peform prediction on the testing data using the model
	//system("C:\svm-predict testingData dataFile.model resultsFile");
	//Generate a graphical result
	//FILE *resultsFile; 
	//resultsFile = fopen("resultsFile","r");	
	//if (resultsFile==NULL) perror ("Error opening file");
	//int f;
	//for(int i=0;i < (height);i++) for(int j=0;j <(width);j++)   
	//	{
	//		fscanf (resultsFile, "%d", &f);
	//		if(f==1)
	//		{
	//			testingData[i*step+j*channels]=255;
	//			testingData[i*step+j*channels+1]=255;
	//			testingData[i*step+j*channels+2]=255;
	//		}
	//		else
	//		{
	//			testingData[i*step+j*channels]=0;
	//			testingData[i*step+j*channels+1]=0;
	//			testingData[i*step+j*channels+2]=0;
	//		}			
	//	}
	//cvShowImage("result",img);	
}
				


