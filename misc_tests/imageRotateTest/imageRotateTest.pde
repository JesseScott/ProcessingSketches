PImage b;

void setup() {
  size(800,800, P3D);
  b = loadImage("sign1.png");
  imageMode(CENTER);
}

void draw() {
  translate(width/2, height/2);
  //rotateZ(135);
  rotate(HALF_PI);
  scale(-1, -1);
  image(b, 0, 0);
  
  
}
