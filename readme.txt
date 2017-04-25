 ******************************************************************************
 *  Name:    Yiran Fan
 *  NetID:   yiranf
 *  Class:   cos429, 2016
 *
 *  Description: readme.txt for the first assignment
 *  Note: 1. Output images are in folder output/ 
 * 	  2. Gradient and magnitude pictures are really sutble, but should 
 *	     reflect correctness. 
 *        3. Corner detection draws squares in cyan. 
 *        4. It takes approximately 5 minutes to run the entire runme.m script.
 ******************************************************************************

 ******************************************************************************
 *  Edge Detection 
 ******************************************************************************
    mandrill.jpg
	Image is the cleanest when sigma=2, t1=.004, t2=.03. The smaller the 
        thresholds get, the more edges it has, and therefore "messier".
    csbldg.jpg
	The outline of the buidling is found when sigma=2, t1=.004, t2=.03.
        The edges between individual blocks are found when sigma=2, t1=.003, 
        t2=.001

 ******************************************************************************
 *  Corner Detection 	
 ******************************************************************************
    csbldg.jpg
	Result is best when sigma=2, gaussian_size=9, neighborhood_size=15, 
	threshold=0.05. When sigma is too big, the image becomes too blurry
	for corners to be detected. If threshold and neighborhood size are 
	both smaller, overlap occurs. However, not every corner is detected
	successfully. 	
    checker.jpg
	Result is best when sigma=2, gaussian_size=9, neighorhood_size=9, 
	threshold=0.05. Every corner is detected, however coordinates of the
	center of the square is slightly shifted depending on the neighborhood
	size.
 ******************************************************************************
 *  Blob Detection
 ******************************************************************************
     butterfly.png
	Result is best when gaussian_size=9, numberOfScale=10, threshold=0.16
	However, there are lots of overlaps and known bug: only one DoG has
	values that pass the threshold. 

