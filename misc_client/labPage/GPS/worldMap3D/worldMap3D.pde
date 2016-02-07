
// IMPORTS
import processing.opengl.*;
import toxi.geom.*;
import java.awt.event.*;
import toxi.geom.Vec2D;
import toxi.geom.Vec3D;
import toxi.math.MathUtils;

// DECLARATIONS
PImage texmap;

// VARIABLES
int sDetail = 32; 
float rotationY = 0;
int globeRadius = 150;

float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5f;
int SINCOS_LENGTH = (int)(360.0f / SINCOS_PRECISION);  

float currentLatitude  = 52.507244;
float currentLongitude = 13.454436;
float zoom = -200;
float y = 0;

private final Vec3D camRot = new Vec3D();
private float currZoom = 1;

// ---------------------------------

void setup() {
  size(480, 800, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  noStroke();

  initializeSphere(sDetail);
  texmap = loadImage("earth_4096.jpg"); 

  addMouseWheelListener(new MouseWheelInput());

}

// ---------------------------------

void draw() {
  background(0,0,10);  
  zoom = y * 5;  
  renderGlobe();

}

// ---------------------------------

public void renderGlobe() {
  callPos();
  pushMatrix();
    translate(width/2, height/2, zoom);
    rotateY(rotationY);
    rotateX(mouseY * 0.01f);
    beginShape();
      lights();
      noStroke();  
      texturedSphere(globeRadius, texmap);
    endShape();
    strokeWeight(3);
    stroke(0, 255, 155);
    point(-pos.x, -pos.y, pos.z);
    line(0, 0, 0, -pos.x, -pos.y, pos.z);
  popMatrix();
  rotationY -= 0.01;
}



// ---------------------------------

class MouseWheelInput implements MouseWheelListener {
  void mouseWheelMoved(MouseWheelEvent e) {
    int step=e.getWheelRotation();
    y = y + step * 5;
  }
}

// ---------------------------------

void keyPressed() {
 saveFrame("save.jpg"); 
}

// ---------------------------------

