
// IMPORTS
import SimpleOpenNI.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;

// DECLARATIONS
SimpleOpenNI context;

// VARIABLES
//openni
float        zoom = 2.0f;
float        rotX = radians(180);  
float        rotY = radians(0);
float        near = 200.00;
float        far = 4500.00;
PVector      screenPos = new PVector();

boolean Recording = false;

// -----------------------------------------------------------------

void setup() {
  // Screen
  size(1280,1024,GLConstants.GLGRAPHICS);
  hint(ENABLE_OPENGL_4X_SMOOTH);
 
  // OPENNI
  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  context.setMirror(false);
  context.enableDepth(1280, 1024, 30);
  
  //Perspective
  perspective(95.0f, float(width)/float(height),10.0f,15000.0f);
 }

// -----------------------------------------------------------------

void draw() {
  frameRate(60);
  //int fps = round(frameRate); println("FPS " + fps);
  context.update();
  background(0);

  pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(2.0);
  
    int[] depthMap = context.depthMap();
    int steps = 4;
    int index;
    PVector realWorldPoint;
  
    strokeWeight(2);
    
    for(int y = 0; y < context.depthHeight(); y += steps) {
      for(int x = 0; x < context.depthWidth(); x += steps) {
        index = x + y * context.depthWidth();
        if(depthMap[index] > 800) { 
          realWorldPoint = context.depthMapRealWorld()[index];
          //if(realWorldPoint.z > near && realWorldPoint.z < far) {
              float fade = map(realWorldPoint.z, near, far, 255.0, 0.0);
              stroke(fade);
              point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z); 
          //}
        }
      } 
    } 
  popMatrix();
  
  if(Recording == true) {
    saveFrame("saved/" + frameCount + ".jpg");  
    
  }
 

  
    
}


// -----------------------------------------------------------------
// Mouse Events

void mousePressed() {
  Recording = true;

}


// -----------------------------------------------------------------

