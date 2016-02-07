

int pointCount = 600;
int freqX = 1;
int freqY = 2;
float phi = 90;
float angle;
float x, y, z; 
float factorX, factorY;

boolean doDrawAnimation = false;

int margin = 25;



void setup() {
  size(600, 600,P3D);
  background(0);
  smooth();

}


void draw() {
  frameRate(15);
  noFill();
  background(0);
  stroke(250,50);
  strokeWeight(1);
  
  freqX ++;
  freqY ++;
  phi ++;

  translate(width/2, height/2);
  factorX = width/2-margin;
  factorY = height/2-margin;


  beginShape();
  for (int i=0; i<=pointCount; i++){
    angle = map(i, 0,pointCount, 0,TWO_PI);

    x = sin(angle*freqX + radians(phi));
    y = sin(angle*freqY);

    x = x * factorX;
    y = y * factorY;
    z = 0-frameCount;

    vertex(x, y, z);
  }
  endShape();

  // saveFrame("####.jpg");
}

void keyPressed() {
  background(0);
}
