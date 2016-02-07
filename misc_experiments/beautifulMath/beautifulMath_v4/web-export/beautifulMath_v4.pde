

int xspacing = 3;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
float theta = 0.0;
float amplitude = 150.0;  // Height of wave
float period = 250.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues1;  
float[] yvalues2; 
float[] yvalues3; 

void setup() {
  size(1000,1000);
  frameRate(30);
  smooth();
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues1 = new float[w/xspacing];
  yvalues2 = new float[w/xspacing];
  yvalues3 = new float[w/xspacing];
}

void draw() {
  background(255);
  println(frameRate);
  calcWave1();
  calcWave2();
  calcWave3();
  renderWave();
}

void calcWave1() {  
  theta += 11.02;
  float x = theta;
  for (int i = 0; i < yvalues1.length; i++) {
    yvalues1[i] = sin(x)*amplitude;
    x+=dx;
  }
}
void calcWave2() {  
  theta += 22.12;
  float x = theta;
  for (int i = 0; i < yvalues2.length; i++) {
    yvalues2[i] = sin(x)*amplitude;
    x+=dx;
  }
}
void calcWave3() {  
  theta += 33.22;
  float x = theta;
  for (int i = 0; i < yvalues3.length; i++) {
    yvalues3[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void renderWave() {
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues1.length; x++) {
    stroke(255,155,55,100);    
    line(0,200+yvalues1[x],x*xspacing,200+yvalues1[x]);
  }
  for (int x = 0; x < yvalues2.length; x++) {
    stroke(155,55,255,100);    
    line(0,500+yvalues2[x],x*xspacing,500+yvalues2[x]);
  }
  for (int x = 0; x < yvalues3.length; x++) {
    stroke(55,255,155,100);    
    line(0,800+yvalues3[x],x*xspacing,800+yvalues3[x]);
  }  


}


void mousePressed() {
  saveFrame("v4-##.jpg");
}

