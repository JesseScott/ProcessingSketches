
//-----------------------------------------------------------------------------------------
/*
 * buttonPressDetect
 *  Kinect / Blob Detection Application To Send TCP Messages To Video Player
 *
 * ---------------------------------------------------------------------------
 * Jesse Scott
 * jesses.co.tt
 * 
 * EOS Light Media
 * eoslightmedia.com
 * ----------------------------------------------------------------------------
 * License:
 * Attribution-Non-Commercial-3.0 Unported (CC BY-NC 3.0)
 * as per http://creativecommons.org/licenses/by-nc/3.0/
 *
 * ----------------------------------------------------------------------------
 * Credits
 * _______
 * 
 * Programming:  Jesse Scott
 * 
 * Libraries:
 *  Network           http://processing.org/reference/libraries/net/index.html     
 *  Blob Detection    http://www.v3ga.net/processing/BlobDetection/
 *  SimpleOpenNI      https://code.google.com/p/simple-openni/
 *            
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------


Edit / Recompile:
--------------------------------------------------------------------------------
To compile from source you need:
	- Processing 1.5.1
	- SimpleOpenNI library : https://code.google.com/p/simple-openni/
	- blobDetection library : http://www.v3ga.net/processing/BlobDetection/

If you need to make changes to the source:
	- Find and edit needed variables, code… save
	- Copy /data folder to desktop
	- Choose 'File > Export Application' (choose OS)
	- Replace /data folder back in directory


If You Are Having Performance Issues:
	- Install SimpleOpenNI 0.26 instead
		(rename 0.27)
		Install in Processing/Libraries
		In 'setupDraw' tab, Lines 14-16, change
			  // Kinect
  			//context = new SimpleOpenNI(this, RUN_MODE_MULTI_THREADED);
  			context = new SimpleOpenNI(this);
		To
	  		// Kinect
  			context = new SimpleOpenNI(this, RUN_MODE_MULTI_THREADED);
  			context = new SimpleOpenNI(this);
		(basically uncomment the multi threaded line and comment the other one)

To Edit XML:
	Open 'settings.xml' and edit the values within the quotes
		name="edit this text"
	Pay attention to the comments, as they give an idea of the values




Calibration:
--------------------------------------------------------------------------------

To Recalibrate:
	- If you are satisfied with the calibration, set it to false
	- If not, set Tag #7 to 'true'
		<tag id="7" name="calibrate">false</tag> 
	- Its a good idea - especially if you are going to DECREASE the amount of buttons, to 		erase all the contents of 'circlePositions.txt' first, as the program will throw an error 	of there are not a matching amount of positions to the number of buttons defined in the 	xml (should be exactly twice as many, as X and Y positions are saved on new lines…)

To Edit Crop Area:
	- You will see a Green square
	- Press 'l' , 'r', 't', or 'b' to edit the left, right, top or bottom lines respectively.
	- Once you've selected your line, use the LEFT, RIGHT, UP, or DOWN keys to move the lines.
	- Adjust the crop lines so the square just bounds the table markers
	- Press 's' to save

To Edit Trigger Positions:
	- Then you will move onto the markers/buttons (no visual cue, sorry)
	- Click the mouse on the markers, and it will save those positions to the 
	'circlePositions.txt' file… later, when the xml Tag #7 is set to
		<tag id="7" name="calibrate">false</tag> 
	it will load those positions and create triggers there… 
	- Click once for each trigger that is on the screen, then click once more to save.
	- Program will jump to detection mode.


	
To Edit Kinect Detection:
	- Open app with Tag #7 set to false (skips calibration)
		<tag id="7" name="calibrate">false</tag> 
	- Make sure Tag #8 is set to true (shows blobs)  
		<tag id="8" name="display">true</tag> 
	- If you see large blobs on the screen, the Kinect is seeing the table
	- Adjust Tag # 6 by decreasing the value slightly
		   <tag id="6" name="tableHeight">1230</tag> 	
	- Save the file, restart the program
	- Continue to adjust until you are just unable to see the table as a blob

To Edit Blob Sizes:
	- Open app with Tag #7 set to false (skips calibration)
		<tag id="7" name="calibrate">false</tag> 
	- Make sure Tag #8 is set to true (shows blobs)  
		<tag id="8" name="display">true</tag> 
	- Experiment by placing your hand within the 'zone'
	- If the 'blob' is too small, or too big, you will just see the white pixels
	- If the 'blob' is within the desired range, you will see a red rectangle around it
	- Edit the minimum & maximum ranges by editing Tags #9 & 10
		<tag id="9" name="blobMin">0.1</tag>    
		<tag id="10" name="blobMax">0.2</tag> 
	- Save the file, restart the program
	- Continue to adjust until you are happy with the size



