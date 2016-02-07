
// IMPORT
import ddf.minim.*;
import oscP5.*;
import netP5.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;
import librarytests.*;
import org.openkinect.*;
import org.openkinect.processing.*;
import blobDetection.*;
import controlP5.*;
import fullscreen.*;
import japplemenubar.*;

// DECLARATIONS
KinectTracker tracker;
Kinect kinect;
SoftFullScreen sfs;
FullScreen fs;
OscP5 oscP5, aP5;
Minim minim;
AudioInput in;
BlobDetection theBlobDetection;
GLGraphicsOffScreen canvas;
GLTextureWindow texWin;
ControlP5 cp5;
PImage depth;

// VARIABLES
boolean newFrame = false;
float bThresh = 0.2; // Blob Detection
int kThresh = 480; // Kinect
boolean drawBlur = false;
boolean drawImg = false;
boolean drawBlob = false;
boolean bg = false;
boolean pts = false;

int picker, touch;
float rx, ry, rz;
float[] xyz = new float[3];


int strokeR = 255;
int strokeG = 255;
int strokeB = 255;
int strokeA = 255;
color strokeColor;
int strokeSize = 1;

int blobR = 255;
int blobG = 255;
int blobB = 255;
int blobA = 255;
color blobColor;
int blobSize = 1;

int blurAmt = 1;

//-----------------------------------------------------------------------------------------

// SETUP
void setup() {
  size(640, 480, GLConstants.GLGRAPHICS);
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  background(0);
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  oscP5 = new OscP5(this, "127.0.0.1", 7110);
  aP5 = new OscP5(this, "192.168.1.102", 12000);
  
  canvas = new GLGraphicsOffScreen(this, 640, 480, true, 4);
  texWin = new GLTextureWindow(this, "Output", 920, 0, 1280, 960, true, false, true);
  texWin.setTexture(canvas.getTexture());
  //canvas.beginDraw();
  //  canvas.hint(ENABLE_OPENGL_4X_SMOOTH);
  //canvas.endDraw();
  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
  theBlobDetection = new BlobDetection(640, 480);
  theBlobDetection.setPosDiscrimination(true);

  cp5 = new ControlP5(this);
  
  cp5.addSlider("STROKE_R", 1, 255, 255, 25, height-90, 50, 10);
  cp5.addSlider("STROKE_G", 1, 255, 255, 25, height-75, 50, 10);
  cp5.addSlider("STROKE_B", 1, 255, 255, 25, height-60, 50, 10);
  cp5.addSlider("STROKE_A", 1, 255, 255, 25, height-45, 50, 10);
  cp5.addSlider("STROKE_SZ", 1, 10, 1, 25, height-30, 50, 10);
  cp5.addBang("RAN_STROKE", 25, height-125, 20, 20);
  
  cp5.addSlider("BLOB_R", 1, 255, 255, 125, height-90, 50, 10);
  cp5.addSlider("BLOB_G", 1, 255, 255, 125, height-75, 50, 10);
  cp5.addSlider("BLOB_B", 1, 255, 255, 125, height-60, 50, 10);
  cp5.addSlider("BLOB_A", 1, 255, 255, 125, height-45, 50, 10);
  cp5.addSlider("BLOB_SZ", 1, 10, 1, 125, height-30, 50, 10);
  cp5.addBang("RAN_BLOB", 125, height-125, 20, 20);

  cp5.addSlider("BLUR_AMT", 1, 15, 1, 250, (height/2), 200, 20);
  cp5.addSlider("KTHRESH", 1, 1500, 980, 250, (height/2)-50, 200, 20);
  cp5.addSlider("BTHRESH", 0.0, 1.0, 0.2, 250, (height/2)-100, 200, 20);
  
  cp5.addToggle("IMG", 50, 100, 30, 30);
  cp5.addToggle("BLURR", 50, 200, 30, 30);
  cp5.addToggle("BLOB", 100, 100, 30, 30);
  cp5.addBang("CLEAR", 100, 200, 30, 30);  
  cp5.addToggle("BG", 150, 100, 30, 30);
  cp5.addToggle("PTS", 150, 200, 30, 30);
  
}

//-----------------------------------------------------------------------------------------

// DRAW
void draw() {
  
  // Info
  frameRate(60);
  int fps = round(frameRate);
  int t = tracker.getThreshold();
  println("KINECT " + t + " BLOB " + bThresh + " FPS " + fps);
 
  // Smooth Rotation
  //rx = xyz[1] /10;
  //ry = xyz[0] /10;
  //rz = xyz[2] /10;  
  
  // Colors
  if(touch == 0) {
    //blobColor = color(blobR, blobG, blobB, blobA);
    //strokeColor = color(strokeR, strokeG, strokeB, strokeA);
  }
  if(touch == 1) {
    //strokeColor = picker;
    //blobColor = picker;
  }
  

  // Gui
  cp5.draw();  


  // BUFFER
  canvas.beginDraw();  
  //canvas.hint(ENABLE_OPENGL_4X_SMOOTH);
  // BG
  if(bg == true) {
    canvas.background(0);  
  }
  
  // Kinect  
  canvas.scale(1.0);
  tracker.track();
  tracker.display();

  //PVector v1 = tracker.getPos();
  canvas.endDraw();
}

//-----------------------------------------------------------------------------------------

void post() {
  texWin.render();  
}

void stop() {
  tracker.quit();
  in.close();
  minim.stop();
  super.stop();
}
