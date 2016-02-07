import processing.opengl.*;

PImage brush;
PGraphics paint;
int touch = 0;

void setup() {
 size(400, 400, OPENGL); 
 brush = loadImage("spotty.png");
 paint = createGraphics(width, height, P2D);
 paint.beginDraw();
 paint.endDraw(); 
}

void draw() {
  background(10);
  if(touch == 1) {
    //paint();
  }
  image(paint, 0, 0);
}
void mouseDragged() {
touch = 1;
paint();
}

void mouseReleased() {
  touch = 0;
}

void paint() {
  float x = lerp(mouseX, pmouseX, 0.8);
  float y = lerp(mouseY, pmouseY, 0.8);
  paint.beginDraw();
  paint.image(brush, x, y);
  paint.endDraw(); 
}
