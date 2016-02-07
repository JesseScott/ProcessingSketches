

int xspacing = 4;   
int w;              
float theta1 = 10.0;
float theta2 = 10.0;
float theta3 = 10.0; 
float amplitude = 175.0;  
float period = 500.0;  
float dx;
float xPos = 0.0;
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
  calcWave_1();
  calcWave_2();
  calcWave_3();
  renderWave();
}

void calcWave_1() {  
  theta1 += 0.02;
  float x1 = theta1;
  for (int i = 0; i < yvalues1.length; i++) {
    yvalues1[i] = sin(x1)*amplitude;
    x1+=dx;
  }
}
void calcWave_2() {  
  theta1 += 20.02;
  float x1 = theta1;
  for (int i = 0; i < yvalues2.length; i++) {
    yvalues2[i] = sin(x1)*amplitude;
    x1+=dx;
  }
}
void calcWave_3() {  
  theta1 += 40.02;
  float x1 = theta1;
  for (int i = 0; i < yvalues3.length; i++) {
    yvalues3[i] = sin(x1)*amplitude;
    x1+=dx;
  }
}



void renderWave() {
  ellipseMode(CENTER);
  xPos += frameCount*0.01;
  if(xPos > width) xPos = 0;
  for (int x = 0; x < yvalues1.length; x++) {
    stroke(255,155,55,150);    
    line(xPos,height/2,x*xspacing,height/2+yvalues1[x]);
  }
  for (int x = 0; x < yvalues2.length; x++) {
    stroke(55,255,155,150);    
    line(xPos*2,height/2,x*xspacing,height/2+yvalues2[x]);
  }
  for (int x = 0; x < yvalues3.length; x++) {
    stroke(155,55,255,150);    
    line(xPos*3,height/2,x*xspacing,height/2+yvalues3[x]);
  } 
  
}


void mousePressed() {
  saveFrame("v6-##.jpg");
}
