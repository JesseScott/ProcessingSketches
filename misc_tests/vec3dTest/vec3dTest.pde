import toxi.geom.*;
import peasy.*;

PeasyCam cam;
Vec3D tx;
float x, y, z;

void setup() {
  size(600, 600, P3D);
  background(255);
  cam=new PeasyCam(this,600);
  
  x = 1;
  y = 1;
  z = 1;
  tx = new Vec3D(x, y, z);
  
}


void draw() {
  background(255);
  translate(0,0,z);
  strokeWeight(z);
  stroke(0,0,0);
  point(tx.x,tx.y,tx.z);
  
  rotateX(frameCount*PI);
  rotateY(frameCount*PI);
  rotateX(frameCount*PI);
  println(x + " " + y + " " + z);
}


void mousePressed() {
  x++;
  y++;
  z++;
  
}
