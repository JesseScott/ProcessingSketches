

int xspacing = 1;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
float theta = 0.0;  // Start angle at 0
float amplitude = 50.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues1;  
float[] yvalues2;
float[] yvalues3;
float[] yvalues4;
float[] yvalues5;
float[] yvalues6;

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
  yvalues6 = new float[w/xspacing];
}

void draw() {
  background(255);
  println(frameRate);
  calcWave();
  renderWave();
}

void calcWave() {  
  theta += 0.2;
  float x = theta;
  for (int i = 0; i < yvalues1.length; i++) {
    yvalues1[i] = sin(x)*amplitude;
    yvalues3[i] = asin(yvalues1[i])*amplitude;   
    yvalues5[i] = sin(yvalues3[i])*amplitude;       
    yvalues2[i] = cos(x)*amplitude;
    yvalues4[i] = acos(yvalues2[i])*amplitude; 
    yvalues6[i] = cos(yvalues4[i])*amplitude;     
    x+=dx;
  }
}



void renderWave() {
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues1.length; x++) {
    stroke(255,155,55,50);    
    ellipse(w*0.2+x*xspacing,200+yvalues1[x],10,10);
  }
  for (int x = 0; x < yvalues2.length; x++) {
    stroke(155,255,55,50);    
    ellipse(w*0.2+x*xspacing,400+yvalues2[x],10,10);
  }
  for (int x = 0; x < yvalues5.length; x++) {
    stroke(155,55,255,250);    
    ellipse(w*0.2+x*xspacing,600+yvalues5[x],10,10);
  }
  for (int x = 0; x < yvalues6.length; x++) {
    stroke(55,155,255,250);    
    ellipse(w*0.2+x*xspacing,800+yvalues6[x],10,10);
  }
  
}

