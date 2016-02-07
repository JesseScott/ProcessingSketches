
// IMPORTS
import hypermedia.video.*;
import java.awt.Rectangle;

// DECLARATIONS
OpenCV opencv;
PImage facePixels;

// VARIABLES
int faceX, faceY, faceW, faceH;

void setup() {
  size( 640, 480 );

  // OpenCV
  opencv = new OpenCV(this);
  opencv.capture(width, height);
  opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT); 
  
}

void draw() {
  // Clear
  background(0);  
  //println(frameRate);
  // OpenCV
  opencv.read();
  image(opencv.image(), 0, 0 );
  Rectangle[] faces = opencv.detect(1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 20, 20);
  
  // Faces
  for(int i = 0; i < faces.length; i++ ) {
    faceX = faces[i].x;
    faceY = faces[i].y;
    faceW = faces[i].width;
    faceH = faces[i].height;
    
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);     
    facePixels = get(faceX +5, faceY +5, faceW -10, faceH -10);
  }
  
  // Background
  fill(0);
  rect(0, 0, width, height);

  // Blurred Pixels
  if(faces.length >= 1) {
    tint(255, 128);
    image(facePixels, faceW + 50, faceY);
    filter(BLUR, int(faces.length * 4));
  }


  
}


public void stop() {
  opencv.stop();
  super.stop(); 
}
