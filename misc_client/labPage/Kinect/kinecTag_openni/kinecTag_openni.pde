
// IMPORTS
import SimpleOpenNI.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;

// DECLARATIONS
SimpleOpenNI context;
RibbonManager ribbonManager;

// VARIABLES
//openni
float        zoom = 2.0f;
float        rotX = radians(180);  
float        rotY = radians(0);
boolean      handsTrackFlag = false;
PVector      screenPos = new PVector();
PVector      handVec = new PVector();
ArrayList    handVecList = new ArrayList();
int          handVecListSize = 10;
String       lastGesture = "";
//ribbon
int paint;
GLGraphicsOffScreen natzke;
int ribbonAlpha = 155;
int ribbonAmount = 3;
int ribbonParticleAmount = 8;
float randomness = .1;
int ribbonCounter = 0;

// -----------------------------------------------------------------

void setup() {
  // Screen
  size(1280,1024,GLConstants.GLGRAPHICS);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  
  // GRAPHICS BUFFER
  natzke = new GLGraphicsOffScreen(this, width, height);
  natzke.beginDraw(); natzke.endDraw(); 
 
  // OPENNI
  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  context.setMirror(true);
  context.enableDepth(1280, 1024, 30);
  context.enableGesture();
  context.enableHands();
  context.addGesture("Wave");
  context.addGesture("Click");
  context.addGesture("RaiseHand");
  context.setSmoothingHands(.5);

  //Perspective
  perspective(95.0f, float(width)/float(height),10.0f,15000.0f);
 }

// -----------------------------------------------------------------

void draw() {
  context.update();
  background(15);

  pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoom);
  
    int[] depthMap = context.depthMap();
    int steps = 2;
    int index;
    PVector realWorldPoint;
  
    strokeWeight(2);
    for(int y = 0; y < context.depthHeight(); y += steps) {
      for(int x = 0; x < context.depthWidth(); x += steps) {
        index = x + y * context.depthWidth();
        if(depthMap[index] > 800) { 
          realWorldPoint = context.depthMapRealWorld()[index];
          if(realWorldPoint.z > 600.0 && realWorldPoint.z < 1800.0) {
              float fade = map(realWorldPoint.z, 600.0, 1800.0, 255.0, 0.0);
              stroke(fade);
              point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z); 
          }
        }
      } 
    } 

    if(handsTrackFlag)  {
      pushStyle();
        colorMode(RGB);
        noFill();
        Iterator itr = handVecList.iterator(); 
        stroke(255);
        strokeWeight(5);
        point(handVec.x,handVec.y,handVec.z);  
      popStyle();   
    }
  popMatrix();
  
  context.convertRealWorldToProjective(handVec, screenPos);
  
  if(paint == 1) {
    drawRibbon();
  } 
  image(natzke.getTexture(), 0, 0);
    
}


// -----------------------------------------------------------------
// hand events

void onCreateHands(int handId,PVector pos,float time) {
  println("GOT A HAND - handId: " + handId + ", pos: " + pos);
  handsTrackFlag = true;
  handVec = pos;
  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId,PVector pos,float time) {
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos);
  handVec = pos;
  handVecList.add(0,pos);
  if(handVecList.size() >= handVecListSize){ // remove the last point 
    handVecList.remove(handVecList.size()-1); 
  }
}

void onDestroyHands(int handId,float time) {
  println("LOST A HAND - handId: " + handId);
  handsTrackFlag = false;
  context.addGesture(lastGesture);
}

// -----------------------------------------------------------------
// gesture events

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition) {
  //println("onRecognizeGesture - strGesture: " + strGesture);
  lastGesture = strGesture;
  context.removeGesture(strGesture); 
  context.startTrackingHands(endPosition); 
}

void onProgressGesture(String strGesture, PVector position,float progress) {
}

// -----------------------------------------------------------------

