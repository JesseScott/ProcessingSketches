/* 

Start in Terminal/CMD Shell:
/.../openNI/Sensebloom-OSCeleton-b2f3f21/osceleton

*/

//-----------------------------------------------------------------------------------------

// IMPORTS
import processing.opengl.*;
import oscP5.*;
import netP5.*;
import codeanticode.glgraphics.*;

// DECLARATIONS
OscP5 oscP5;
RibbonManager ribbonManager;

// VARIABLES
int ribbonAlpha = 255;
int ribbonAmount = 5;
int ribbonParticleAmount = 8;
float randomness = .1;
int ribbonCounter = 0;
float x, y;
Hashtable<Integer, Skeleton> skels = new Hashtable<Integer, Skeleton>();
float scale;
float[] xyz = new float[3];
int paint;                  
GLGraphicsOffScreen natzke;

//-----------------------------------------------------------------------------------------
// Setup

void setup() {
  size(800, 600, GLConstants.GLGRAPHICS); 
  hint(ENABLE_OPENGL_4X_SMOOTH);
  background(0);
  
  // OSC
  oscP5 = new OscP5(this, "127.0.0.1", 7110);
  
  // Painting
  natzke = new GLGraphicsOffScreen(this, width, height);
  natzke.beginDraw(); 
  natzke.endDraw(); 
  
} 

//-----------------------------------------------------------------------------------------
// Draw

void draw() {
  translate(width/2, height/2);
  background(255);
  stroke(0);
  fill(0);
  
  // Skeleton
  for (Skeleton s: skels.values()) {
    translate(0-width/2, 0-height/2, -10);
    textureMode(NORMALIZED);
    // Skull
    pushMatrix();
      translate(0, 0, -2);
      ellipse(s.headCoords[0]*width, s.headCoords[1]*height, 30, 35);
    popMatrix();
    noFill();
    strokeWeight(40);
    // Neck
    beginShape();
      vertex(s.neckCoords[0]*width, s.neckCoords[1]*height, -1);
      vertex(s.headCoords[0]*width, s.headCoords[1]*height, -1);
    endShape();
    // R Arm
    beginShape();
      vertex(s.rShoulderCoords[0]*width, s.rShoulderCoords[1]*height, -1);
      vertex(s.rElbowCoords[0]*width, s.rElbowCoords[1]*height, -1);
      vertex(s.rHandCoords[0]*width, s.rHandCoords[1]*height, -1);
    endShape();
    // L Arm
    beginShape();
      vertex(s.lShoulderCoords[0]*width, s.lShoulderCoords[1]*height, -1);
      vertex(s.lElbowCoords[0]*width, s.lElbowCoords[1]*height, -1);
      vertex(s.lHandCoords[0]*width, s.lHandCoords[1]*height, -1);
    endShape();
    // Torso
    beginShape();
      vertex(s.rShoulderCoords[0]*width, s.rShoulderCoords[1]*height, -1);
      vertex(s.lShoulderCoords[0]*width, s.lShoulderCoords[1]*height, -1);
      vertex(s.lHipCoords[0]*width, s.lHipCoords[1]*height, -1);
      vertex(s.rHipCoords[0]*width, s.rHipCoords[1]*height, -1);
      vertex(s.rShoulderCoords[0]*width, s.rShoulderCoords[1]*height, -1);
    endShape();
    // Right Leg
    beginShape();
      vertex(s.rHipCoords[0]*width, s.rHipCoords[1]*height, -1);
      vertex(s.rKneeCoords[0]*width, s.rKneeCoords[1]*height, -1);
      vertex(s.rFootCoords[0]*width, s.rFootCoords[1]*height, -1);
    endShape();
    // Left Leg
    beginShape();
      vertex(s.lHipCoords[0]*width, s.lHipCoords[1]*height, -1);
      vertex(s.lKneeCoords[0]*width, s.lKneeCoords[1]*height, -1);
      vertex(s.lFootCoords[0]*width, s.lFootCoords[1]*height, -1);
    endShape();

    // Right Hand
    for (float[] i: s.handCoords) {
      x = i[0] * width;
      y = i[1] * height;
    } 
  }
  
  // Paint Event
  if(paint == 1) { 
    natzke();
  }
  image(natzke.getTexture(), 0, 0);
  
} 

//-----------------------------------------------------------------------------------------
// PGraphics

void natzke() {
  natzke.beginDraw();
    natzke.pushMatrix();
    ribbonManager.update(x, y);
    natzke.popMatrix();
  natzke.endDraw();
}

void erase() {
  natzke.beginDraw();
    natzke.clear(0, 0, 0, 0);
  natzke.endDraw();
}


//-----------------------------------------------------------------------------------------
// Mouse Functions

void mousePressed() {
  if(mouseButton == LEFT) {
    paint = 1; // Start Drawing
    ribbonManager = new RibbonManager(ribbonAmount, ribbonParticleAmount, randomness, ribbonCounter);
  }
  else if(mouseButton == RIGHT) {
    erase(); // Clear Drawing
  }
}
  
void mouseReleased() {
  paint = 0; // Stop Drawing
}


void keyPressed() {
 if(key == 's') {
  saveFrame("save.tif");
 }   
}




