
// IMPORTS
//--------
import processing.opengl.*;
import oscP5.*;
import netP5.*;
import sms.*;
import lmu.*;
import hypermedia.video.*;
import processing.video.*;
import java.awt.Rectangle;
import ddf.minim.*;
import ddf.minim.analysis.*;


// DECLARATIONS
//-------------
OpenCV opencv;
OscP5 incoming;
Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener listener;
FFT fft;

// VARIABLES
//----------

// OSC
float pitchValue;
float attackValue;
float levelValue;

// SMS
int[] SMSVals;

// LMU
int[] ALSVals;
int[] ALSStart;
int ALSLeft;
int ALSRight;

// MODES
int drawMode = 3;


//-----------------------------------------------------------------

void setup() {
  // Screen
  size(screenWidth, screenHeight, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  smooth();
  noCursor();
  
  // Color
  colorMode(RGB);
  
  // OSC
  incoming = new OscP5(this,9997);
  
  // Open CV
  opencv = new OpenCV(this);
  opencv.capture(320, 240);
  opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT);
  
  // Minim
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(250);
  listener = new BeatListener(beat, in);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.linAverages(128);  
  
  // AMBIENT LIGHT
  ALSStart = LmuTracker.getLMUArray();
  ALSLeft  = ALSStart[0];
  ALSRight = ALSStart[1];

  // MODE 1
  ballSize = screenWidth/10;
  sphereDetail(18);
  
  // MODE 2
  vis = createGraphics(width, height, P2D);
  _pos[0] = width/2; 
  _pos[1] = height/2;
  //_pos[2] = 1;
  pos[0] = width/2; 
  pos[1] = height/2;
  //pos[2] = 1;
  
  // MODE 3
  cvFont = loadFont("AlBayan-96.vlw");
  
  
}


//-----------------------------------------------------------------

void draw() {
  // OPENGL
  enableVSync();
  
  // SMS
  SMSVals = Unimotion.getSMSArray();
  
  // LMU
  ALSVals = LmuTracker.getLMUArray();
  
  // SCREEN
  background(0);
  drawingMode();
  
  // FRAME RATE
  frameRate(60);
  if(frameCount % 600 == 0) {
    int fps = round(frameRate);
    println("Frame Rate is " + fps + " FPS");
    println("Draw Mode is " + drawMode);
    println(" ");
  }

  
}

//-----------------------------------------------------------------

public void stop() {
  opencv.stop();
  in.close();
  minim.stop();
  super.stop(); 
}
