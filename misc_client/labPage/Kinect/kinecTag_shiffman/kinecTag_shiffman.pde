
// IMPORTS
import processing.opengl.*;
import codeanticode.glgraphics.*;
import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;

// DECLARATIONS
KinectTracker tracker;
Kinect kinect;
RibbonManager ribbonManager;

// VARIABLES
boolean state;
//kinect
PImage depth;
//ribbon
GLGraphicsOffScreen natzke;
int ribbonAlpha = 155;
int ribbonAmount = 3;
int ribbonParticleAmount = 8;
float randomness = .1;
int ribbonCounter = 0;
int paint = 0;

// SETUP
void setup() {
  size(640,480,GLConstants.GLGRAPHICS);
  background(0);
  
  // Create and instantiate our Graphics Buffer
  natzke = new GLGraphicsOffScreen(this, width, height);
  natzke.beginDraw(); 
  natzke.endDraw(); 
  
  // Start the Kinect
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
}


// DRAW
void draw() {
 
  // Call kinectTracker
  tracker.track();
  tracker.display();
  int t = tracker.getThreshold();

  // Tracking
  PVector v1 = tracker.getPos();
  PVector v2 = tracker.getLerpedPos();
  
  // Left Half
  fill(250,100,50);
  noStroke();
  ellipse(640-v1.x,v1.y,20,20); 
  
  // Right Half
  if(paint == 1) {
   drawNatzke(); 
  }
  image(natzke.getTexture(), 0, 0);

  println("KINECT THRESH =  " + t + "  " + "FRAMERATE = " + frameRate);

}


