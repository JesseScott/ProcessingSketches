// IMPORTS
import hypermedia.video.*;
import processing.video.*;
import java.awt.Rectangle;

// DECLARATIONS
OpenCV opencv;
Movie happy;
Movie sad;

// VARIABLES


// SETUP
void setup() {
 size(640, 480);
 
 sad = new Movie(this, "sad.mov");
 sad.loop();
 happy = new Movie(this, "happy.mov");
 happy.loop();
 
 opencv = new OpenCV(this);
 opencv.capture(width, height);
 opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT);  
}

// MOVIE
void movieHappy(Movie happy) {
  happy.read();
}
void movieSad(Movie sad) {
  sad.read();
}

// OPENCV
public void stop() {
  opencv.stop();
  super.stop();
}

// DRAW
void draw() {
  opencv.read();
  opencv.convert(GRAY);
  Rectangle[] faces = opencv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);

  //image(opencv.image(), 0, 0);
  if(faces.length == 0) {
    image(sad, 0, 0);
  }
  else if(faces.length <= 1) {
    image(happy, 0, 0);
  }  
  
  
}



