// Lissajous Curve

float a = 0.1;
float b = 0.1;
float ab;
PVector v1;


void setup() {
  size(1000,1000);
  frameRate(30);
  smooth();
  v1 = new PVector(1000,1000);


}

void draw() {
  background(255);
  calcWave();
  renderWave();
  
}

void calcWave() {  
  a += 1;
  b += 2;
  ab = a/b;
  
}





void renderWave() {
  
  for( int i = 0; i < 100; i++) {
    stroke(i, i*2, i*3);
    line(a,b,sin(a)/sin(b),sin(b));
  }
}

