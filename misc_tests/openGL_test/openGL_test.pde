import processing.opengl.*;
PGraphics pg;

void setup() {
  size(600, 600,OPENGL);
  pg = createGraphics(600, 600, P3D);
  
}

void draw() {
 
  pg.beginDraw();
  pg.background(random(255));
  pg.fill(255);
  pg.ellipse(width/2,height/2,100,100);
  pg.endDraw();
  //image(pg,0,0);
  background(pg); //use bg instead of image works
  println(frameCount);
}
