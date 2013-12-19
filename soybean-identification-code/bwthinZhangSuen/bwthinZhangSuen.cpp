// BAfinamento.cpp : implementation file
//

#include "mex.h"


#define P1(MAT,Y,X) (MAT[Y  ][X  ])
#define P2(MAT,Y,X) (MAT[Y-1][X  ])
#define P3(MAT,Y,X) (MAT[Y-1][X+1])
#define P4(MAT,Y,X) (MAT[Y  ][X+1])
#define P5(MAT,Y,X) (MAT[Y+1][X+1])
#define P6(MAT,Y,X) (MAT[Y+1][X  ])
#define P7(MAT,Y,X) (MAT[Y+1][X-1])
#define P8(MAT,Y,X) (MAT[Y  ][X-1])
#define P9(MAT,Y,X) (MAT[Y-1][X-1])

//#define P1(MAT,X,Y) (MAT.GetAt(X  ))->GetAt(Y)
//#define P2(MAT,X,Y) (MAT.GetAt(X-1))->GetAt(Y)
//#define P3(MAT,X,Y) (MAT.GetAt(X-1))->GetAt(Y+1)
//#define P4(MAT,X,Y) (MAT.GetAt(X  ))->GetAt(Y+1)
//#define P5(MAT,X,Y) (MAT.GetAt(X+1))->GetAt(Y+1)
//#define P6(MAT,X,Y) (MAT.GetAt(X+1))->GetAt(Y)
//#define P7(MAT,X,Y) (MAT.GetAt(X+1))->GetAt(Y-1)
//#define P8(MAT,X,Y) (MAT.GetAt(X  ))->GetAt(Y-1)
//#define P9(MAT,X,Y) (MAT.GetAt(X-1))->GetAt(Y-1)


//	P9	 P2	 P3
//	P8	 P1	 P4
//	P7	 P6  P5	

typedef struct tagPoint{
	int Px,Py;
}PixelPoint;

// Afinamento - Zhang & Suen
int AfinamentoZhangSuen(unsigned char* pImgIn,unsigned char* pImgOut,mwSize iHeight,mwSize  iWidth)
{
	int            idx;
	int		       ThiningContinue;
	int			   line, col,iPoint,bDelete;
	unsigned char  Conectivity=0, Neighboors=0;
	int            nTotalPoints,nCurrList,nNextList,nDeleteList;

//	if ( !(VerifyConsistentIn() && VerifyConsistentOut()) )
//		return FALSE;

//	CopyImageInOut();

	int** pImgOut1 = new int*[iHeight+2];
	int** pImgOut2 = new int*[iHeight+2];
	pImgOut1[0] = new int[(iHeight+2)*(iWidth+2)];
	pImgOut2[0] = new int[(iHeight+2)*(iWidth+2)];
	for(idx=1;idx<(int)iHeight+2;idx++)
	{
		pImgOut1[idx] = pImgOut1[0]+idx*(iWidth+2);
		pImgOut2[idx] = pImgOut2[0]+idx*(iWidth+2);
	}

	nTotalPoints = 0;
	for (line = 0; line < (int)iHeight; line++)
	{
		for (col = 0; col < (int)iWidth; col++)
		{
			if ( (pImgIn[line+col*iHeight] == 1) )
			{
				nTotalPoints++;
				pImgOut1[line+1][col+1] = 1;
				pImgOut2[line+1][col+1] = 1;
			}
			else
			{
				pImgOut1[line+1][col+1] = 0;
				pImgOut2[line+1][col+1] = 0;
			}
		}
	}

	for (line = 0; line < (int)iHeight+2; line++)
	{
		pImgOut1[line][       0] = 0;pImgOut2[line][       0] = 0;		
		pImgOut1[line][iWidth+1] = 0;pImgOut2[line][iWidth+1] = 0;
	}
	for (col  = 0; col  < (int)iWidth+2 ; col++ )
	{
		pImgOut1[        0][col] = 0;pImgOut2[        0][col] = 0;
		pImgOut1[iHeight+1][col] = 0;pImgOut2[iHeight+1][col] = 0;
	}
	

	PixelPoint* pList1 = new PixelPoint[nTotalPoints];
	PixelPoint* pList2 = new PixelPoint[nTotalPoints];
	PixelPoint* pList3 = new PixelPoint[nTotalPoints];
	PixelPoint Point;

	nTotalPoints = 0;
	for (line = 0; line < (int) iHeight+2; line++)
	{
		Point.Py = line;
		for (col = 0; col < (int) iWidth+2; col++)
		{
			if ( pImgOut1[line][col] == 1)
			{
				Point.Px = col;
				pList1[nTotalPoints++] = Point;
			}
		}
	}

	PixelPoint* pCurrList   = pList1; nCurrList = nTotalPoints;
	PixelPoint* pNextList   = pList2; nNextList = 0;nDeleteList = 0;
	PixelPoint* pDeleteList = pList3; nDeleteList = 0;

	int it=0;
	do {
		it++;
		ThiningContinue = 0;

		// First Sub-Iteraction
		for(iPoint = 0; iPoint < nCurrList; iPoint++)
		{
			bDelete = 1;

			Point = pCurrList[iPoint];
			line = Point.Py;
			col  = Point.Px;

			if (line >= iHeight+2 || col >= iWidth+2)
				printf("%d x %d\n",line,col);

			Neighboors  = 0;
			Conectivity = 0;

			// Connectivity number must be 1;
			Conectivity =  (P2(pImgOut1,line,col) == 0 && P3(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P3(pImgOut1,line,col) == 0 && P4(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P4(pImgOut1,line,col) == 0 && P5(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P5(pImgOut1,line,col) == 0 && P6(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P6(pImgOut1,line,col) == 0 && P7(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P7(pImgOut1,line,col) == 0 && P8(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P8(pImgOut1,line,col) == 0 && P9(pImgOut1,line,col)== 1) ? 1 : 0;
			Conectivity += (P9(pImgOut1,line,col) == 0 && P2(pImgOut1,line,col)== 1) ? 1 : 0;

			if (Conectivity != 1)
			{	bDelete = 0; goto end1;}

			// 2 <= BlackNeighboors <= 6
			Neighboors =	P2(pImgOut1,line,col) + P3(pImgOut1,line,col) + P4(pImgOut1,line,col) + P5(pImgOut1,line,col) + 
							P6(pImgOut1,line,col) + P7(pImgOut1,line,col) + P8(pImgOut1,line,col) + P9(pImgOut1,line,col);

			if (Neighboors < 2 || Neighboors > 6)
			{	bDelete = 0; goto end1;}

			// At least one of P2, P4 and P6 are background
			Neighboors = 0;
			Neighboors =  P2(pImgOut1,line,col) * P4(pImgOut1,line,col) * P6(pImgOut1,line,col);

			if (Neighboors != 0)
			{	bDelete = 0; goto end1;}

			// At least one of P4, P6 and P8 are background
			Neighboors = 0;
			Neighboors =  P4(pImgOut1,line,col) * P6(pImgOut1,line,col) * P8(pImgOut1,line,col);

			if (Neighboors != 0)
			{	bDelete = 0; goto end1;}

end1:
			if (bDelete)
			{
				// Actual Pixel was deleted
				pImgOut2[line][col] = 0;
				pDeleteList[nDeleteList++] = Point;
				ThiningContinue = 1;
			}
			else
			{
				pImgOut2[line][col] = 1;
				pNextList[nNextList++] = Point;
			}
		}
		
		for(iPoint = 0; iPoint < nDeleteList; iPoint++)
		{
			Point = pDeleteList[iPoint];
			pImgOut1[Point.Py][Point.Px] = 0;
		}

		nDeleteList = 0;
		pCurrList=pList2;nCurrList = nNextList;
		pNextList=pList1;nNextList = 0;

		// Second Sub-Iteraction
		for(iPoint = 0; iPoint < nCurrList; iPoint++)
		{
			bDelete = 1;

			Point = pCurrList[iPoint];
			line = Point.Py;
			col  = Point.Px;

			if (line >= iHeight+2 || col >= iWidth+2)
				printf("%d x %d\n",line,col);


			Neighboors = 0;
			Conectivity= 0;

			// Connectivity number must be 1;
			Conectivity  = (P2(pImgOut2,line,col) == 0 && P3(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P3(pImgOut2,line,col) == 0 && P4(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P4(pImgOut2,line,col) == 0 && P5(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P5(pImgOut2,line,col) == 0 && P6(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P6(pImgOut2,line,col) == 0 && P7(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P7(pImgOut2,line,col) == 0 && P8(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P8(pImgOut2,line,col) == 0 && P9(pImgOut2,line,col)== 1) ? 1 : 0;
			Conectivity += (P9(pImgOut2,line,col) == 0 && P2(pImgOut2,line,col)== 1) ? 1 : 0;

			if (Conectivity != 1)
			{	bDelete = 0; goto end2;}

			// 2 <= BlackNeighboors <= 6

			Neighboors =	P2(pImgOut2,line,col) + P3(pImgOut2,line,col) + P4(pImgOut2,line,col) + P5(pImgOut2,line,col) + 
							P6(pImgOut2,line,col) + P7(pImgOut2,line,col) + P8(pImgOut2,line,col) + P9(pImgOut2,line,col);

			if (Neighboors < 2 || Neighboors > 6)
			{	bDelete = 0; goto end2;}

			// At least one of P2, P4 and P6 are background
			Neighboors = 0;
			Neighboors =  P2(pImgOut2,line,col) * P4(pImgOut2,line,col) * P8(pImgOut2,line,col);

			if (Neighboors != 0)
			{	bDelete = 0; goto end2;}

			// At least one of P2, P6 and P8 are background
			Neighboors = 0;
			Neighboors =  P2(pImgOut2,line,col) * P6(pImgOut2,line,col) * P8(pImgOut2,line,col);

			if (Neighboors != 0)
			{	bDelete = 0; goto end2;}

end2:
			if (bDelete)
			{
				// Actual Pixel was deleted
				pImgOut1[line][col] = 0;
				pDeleteList[nDeleteList++] = Point;
				ThiningContinue = 1;
			}
			else
			{
				pImgOut1[line][col] = 1;
				pNextList[nNextList++] = Point;
			}
		}

		for(iPoint = 0; iPoint < nDeleteList; iPoint++)
		{
			Point = pDeleteList[iPoint];
			pImgOut2[Point.Py][Point.Px] = 0;
		}

		nDeleteList = 0;
		pCurrList=pList1;nCurrList = nNextList;
		pNextList=pList2;nNextList = 0;

//		printf("iteracao: %d\n",it);

	} while(ThiningContinue);


	for (line = 0; line < (int)iHeight; line++)
	{
		for (col = 0; col < (int)iWidth; col++)
		{
			if( pImgOut1[line+1][col+1] == 1)
//				SetPixel((DWORD) col, (DWORD) (m_Height-1)-line,RGB(255,255,255));
				pImgOut[line+col*iHeight] = 1;
			else
//				SetPixel((DWORD) col, (DWORD) (m_Height-1)-line,RGB(0,0,0));
				pImgOut[line+col*iHeight] = 0;
		}
	}


//	for (line = 0; line < (int)iHeight; line++)
//	{
//		pImgOut[line+        0 *iHeight] = 1;
//		pImgOut[line+(iWidth-1)*iHeight] = 1;
//	}

	delete pList1;
	delete pList2;
	delete pList3;
	delete pImgOut1[0];
	delete pImgOut1;
	delete pImgOut2[0];
	delete pImgOut2;
	
	return 1;
}



/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    unsigned char *inMatrix;               /* 1xN input matrix */
    mwSize nrows,ncols;             /* size of matrix */
    unsigned char *outMatrix;              /* output matrix */

    /* check for proper number of arguments */
    if(nrhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:bwthinZhangSuen:nrhs","One input is required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:bwthinZhangSuen:nlhs","One output is required.");
    }

    /* make sure the first input argument is logical */
    if( !mxIsUint8(prhs[0]) && !mxIsLogical(prhs[0]) )
	{
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notScalar","Input must be uint8 or logical!");
    }
    
    /* check that number of rows and cols in first input argument is 1 */
    if ( (mxGetM(prhs[0])==1) || (mxGetN(prhs[0])==1) ) 
	{
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a bidimensional matrix!");
    }
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix = (unsigned char*)mxGetData(prhs[0]);


    /* get dimensions of the input matrix */
    nrows = mxGetM(prhs[0]);
	ncols = mxGetN(prhs[0]);

	if (mxIsUint8(prhs[0]))
	{
		/* binarizing uint8 matrix */
		mwSize row,col;
		for(row=0;row<nrows;row++)
			for(col=0;col<ncols;col++)
				inMatrix[row*ncols+col] = (inMatrix[row*ncols+col] == 0) ? 0:1;
	}

//	char   tmp[BUFSIZ];
//	sprintf(tmp,"element size: %d\n",mxGetElementSize(prhs[0]));mexWarnMsgTxt(tmp);
//	sprintf(tmp,"nrows: %d\n",nrows);mexWarnMsgTxt(tmp);
//	sprintf(tmp,"ncols: %d\n",ncols);mexWarnMsgTxt(tmp);

    /* create the output matrix */
    plhs[0] = mxCreateLogicalMatrix(nrows,ncols);

    /* get a pointer to the real data in the output matrix */
    outMatrix = (unsigned char*)mxGetData(plhs[0]);

//	char txt[BUFSIZ];
//	sprintf(txt,"dimensions: %d x %d",nrows,ncols);
//	mexWarnMsgTxt(txt);

    /* call the computational routine */
    AfinamentoZhangSuen(inMatrix,outMatrix,nrows,ncols);
}
