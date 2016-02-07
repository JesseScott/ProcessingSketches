
//-----------------------------------------------------------------

int numFaces = 0;
PFont cvFont;

//-------------

void Mode_3() {
  // FACE COUNTER
  pushStyle();    
  pushMatrix();
  
  // Screen
  background(0);
  fill(255);
  
  // Font
  textFont(cvFont, 96);
  textAlign(LEFT);
 
  // CV
  opencv.read();
  opencv.convert(GRAY);
  Rectangle[] faces = opencv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);
  
  numFaces = faces.length + 1;
  
  // TEXT
  text("Currently, there is ", width/4, height/2 - 96);
  text(numFaces + " persons ", width/4, height/2);
  text("within my field of vision.", width/4, height/2 + 96);
  

  popMatrix();
  popStyle();
}



//-----------------------------------------------------------------

