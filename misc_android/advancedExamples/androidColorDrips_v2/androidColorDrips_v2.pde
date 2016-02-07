// Android Example for Weave Magazine 02.11
//
// androidColorDrips.pde
// Shows the advanced use of Touchscreen drawing
//
// Written by “DeadDealer” http://www.openprocessing.org/visuals/?visualID=3260
// Adapted for android use by Cedric Kiefer / Jesse Scott
// www.onformative.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

ColorDrop[] drops, delDrops;
 
color pencil = 255; // color of the spray painter
int dropAlpha = 255;
int randomDrop = 25; // percentaged possibility to generate a color drop
float PMX = mouseX;
float PMY = mouseY;
 
//-----------------------------------------------------------------------------------------

void setup() {
  size(screenWidth, screenHeight);

  drops = new ColorDrop[0];
  delDrops = new ColorDrop[0];
 
  stroke(pencil, dropAlpha);
  strokeWeight(20);
  background(0);
  smooth();
}

//-----------------------------------------------------------------------------------------

void draw() {
  //println(frameRate);
  for (int i = 0; i < drops.length; i++) {
    if (drops[i].moveDrop())
      drops[i].drawDrop();
  }
  
    stroke(100);
  strokeWeight(1);
  noFill();
  rect(0, 0, width-1, height-1);
}
 
//-----------------------------------------------------------------------------------------
 
void mouseReleased() {
 println("RELEASED");
 PMX = pmouseX;
 PMY = pmouseY; 
} 

void mousePressed() {
  println("PRESSED");
  PMX = mouseX;
  PMY = mouseY;
}
 
void mouseDragged() {
 println("DRAGGED");
    
    stroke(pencil, dropAlpha);
    float r = map(mouseX, 0, screenWidth, 0, 255);
    float b = map(mouseY, 0, screenHeight, 0, 255); 
    //stroke(255-r, (r+b)/2, 255-b);
    stroke(255);
    PMX = mouseX;
    PMY = mouseY;

    //strokeWeight(30-constrain(dist(pmouseX, pmouseY, mouseX, mouseY), 0, 25));
    strokeWeight(5);
    //line(me.x, me.y, mouseX, mouseY);
 
    // drip generating
    int randomValueForDrop = floor(random(0, 100));
    if (randomValueForDrop <= randomDrop) {
      ColorDrop setDrop = new ColorDrop(mouseX, mouseY, pencil);
      drops = (ColorDrop[]) append(drops, setDrop);
    } 
}

//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent me) {
  int numPointers = me.getPointerCount();
  for(int i=0; i < numPointers; i++) {
    float x = me.getX(i);
    float y = me.getY(i);
    line(pmouseX, pmouseY, x, y);
  }
  return super.surfaceTouchEvent(me);
}

//-----------------------------------------------------------------------------------------

void keyPressed() {
    // Clear Screen if the MENU key is pressed
    drops = delDrops;
    background(0);
}

//-----------------------------------------------------------------------------------------

class ColorDrop {
  float initPosX = 0.0, initPosY = 0.0; // initial position of each drop
  // variable to set and get position of painting drop 
  // (if initPosY+posY < initPosY+lengthDrop then move the drop down)
  float posY = 0.0; 
  float lengthDrop = random(20, 150); // length of the drop line
  float diameterDrop = random(1.1, 2.0); // diameter of the drop
  float dropSpeed = random(0.1, 5);
  color colorDrop; // color of the drop
 
    ColorDrop(float initPosX_, float initPosY_, color colorDrop_) { // position & color
    initPosX = initPosX_;
    initPosY = initPosY_;
    colorDrop = colorDrop_;
  }
  
  // position, color & length
  ColorDrop(float initPosX_, float initPosY_, color colorDrop_, float lengthDrop_) { 
    initPosX = initPosX_;
    initPosY = initPosY_;
    lengthDrop = lengthDrop_;
    colorDrop = colorDrop_;
  }
  
  // position, color, length & width
  ColorDrop(float initPosX_, float initPosY_, color colorDrop_, float lengthDrop_, float diameterDrop_) { 
    initPosX = initPosX_;
    initPosY = initPosY_;
    lengthDrop = lengthDrop_;
    diameterDrop = diameterDrop_;
    colorDrop = colorDrop_;
  }
 
  boolean moveDrop() {
    if (posY <= lengthDrop) {
      posY += noise(1) * dropSpeed;
      return true;
    }
    else {
      return false;
    }
  }
 
  void drawDrop() {
    noStroke();    
    float r = map(initPosX, 0, screenWidth, 0, 255);
    float b = map(initPosY, 0, screenHeight, 0, 255); 
    fill(255-r,0,255-b);
    //  fill(colorDrop, 255 - int(posY / lengthDrop * 250));
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(initPosX, initPosY + posY, diameterDrop, diameterDrop * 2);
  }
  
}
