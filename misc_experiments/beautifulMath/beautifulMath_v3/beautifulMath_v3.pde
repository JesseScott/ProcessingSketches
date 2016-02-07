

int xspacing = 3;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
float theta = 0.0;  // Start angle at 0
float amplitude = 150.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues1;  
float[] yvalues2;
float[] yvalues3;
float[] yvalues4;
float[] yvalues5;

void setup() {
  size(1000,1000);
  frameRate(30);
  smooth();
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues1 = new float[w/xspacing];
  yvalues2 = new float[w/xspacing];
  yvalues3 = new float[w/xspacing];
  yvalues4 = new float[w/xspacing];
  yvalues5 = new float[w/xspacing];
}

void draw() {
  background(255);
  println(frameRate);
  calcWave_1();
  calcWave_2();
  calcWave_3();
  calcWave_4();
  calcWave_5();
  renderWave();
}

void calcWave_1() {  
  theta += 1;
  float x = theta;
  for (int i = 0; i < yvalues1.length; i++) {
    yvalues1[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void calcWave_2() {
  theta += 2;
  float x = theta;
  for (int i = 0; i < yvalues2.length; i++) {
    yvalues2[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void calcWave_3() {
  theta += 3;
  float x = theta;
  for (int i = 0; i < yvalues3.length; i++) {
    yvalues3[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void calcWave_4() {
  theta += 4;
  float x = theta;
  for (int i = 0; i < yvalues4.length; i++) {
    yvalues4[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void calcWave_5() {
  theta += 5;
  float x = theta;
  for (int i = 0; i < yvalues5.length; i++) {
    yvalues5[i] = sin(x)*amplitude;
    x+=dx;
  }
}

void renderWave() {
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues1.length; x++) {
    stroke(255,155,55,50);    
    line(0,0,x*xspacing,200+yvalues1[x]);
  }
  for (int x = 0; x < yvalues2.length; x++) {
    stroke(155,255,55,50);    
    line(0,0,x*xspacing,350+yvalues2[x]);
  }
  for (int x = 0; x < yvalues3.length; x++) {
    stroke(155,55,255,50);    
    line(0,0,x*xspacing,500+yvalues3[x]);
  }
  for (int x = 0; x < yvalues4.length; x++) {
    stroke(255,55,155,50);    
    line(0,0,x*xspacing,650+yvalues4[x]);
  }
  for (int x = 0; x < yvalues5.length; x++) {
    stroke(55,255,155,50);    
    line(0,0,x*xspacing,800+yvalues5[x]);
  }
  
}

void mousePressed() {
  saveFrame("v3-##.jpg");
  
}
