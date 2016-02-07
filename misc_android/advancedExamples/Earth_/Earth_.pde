import processing.opengl.*;
import toxi.geom.*;
import java.awt.event.*;
import toxi.geom.Vec2D;
import toxi.geom.Vec3D;
import toxi.math.MathUtils;

PImage texmap;

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

public void setup() {
  size(480, 800, OPENGL);
  addMouseWheelListener(new MouseWheelInput());
  texmap = loadImage("earth2.jpg");    
  initializeSphere(sDetail);
  noStroke();

}

// ---------------------------------

public void draw() {
  background(#d2c09c); 
 background(0,0,10);  
   zoom = y * 5;  
  renderGlobe();
}

// ---------------------------------

class MouseWheelInput implements MouseWheelListener {
  void mouseWheelMoved(MouseWheelEvent e) {
    int step=e.getWheelRotation();
    y=y+step*5;
  }
}

// ---------------------------------

Vec2D gps;
Vec3D pos;

public void setLatLon() {
  // set to Berlin
  gps = new Vec2D(13.3978, 52.5329);
}

public Vec3D computePosOnSphere(int globeRadius) {
  pos = new Vec3D(globeRadius, MathUtils.radians(gps.x) + MathUtils.PI,MathUtils.radians(gps.y)).toCartesian();
  return pos;
}

public void callPos() {
  setLatLon();
  computePosOnSphere(globeRadius); 
}

// ---------------------------------

void keyPressed() {
 saveFrame("save.jpg"); 
}

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

