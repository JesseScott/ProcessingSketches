int armAngle = 0;
int angleChange = 1;
final int angleLimit = 20;
PImage body;
PImage arm;

void setup() {
 size(225, 225, P3D);
 background(255); 
 frameRate(30);
 imageMode(CENTER);
 body = loadImage("body.png");
 arm = loadImage("arm.png");
}

void draw() {
  background(255);
  pushMatrix();
    image(body, 112, 112);
    drawArm();
    armAngle += angleChange;
    if (armAngle > angleLimit || armAngle < 0-angleLimit) {
      angleChange = -angleChange;
      armAngle += angleChange;
    }
  popMatrix();
}

void drawArm() {
 pushMatrix();
 translate(0, 98, 0);
 rotateX(radians(-armAngle));
 translate(0,-98.0);
 image(arm, 10+112+51, 44+53);

 popMatrix();
}
