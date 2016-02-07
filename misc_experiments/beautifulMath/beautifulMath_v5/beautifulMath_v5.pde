

int xspacing = 4;   
int w;              
float theta1 = 10.0;
float theta2 = 10.0;
float theta3 = 10.0; 
float amplitude = 175.0;  
float period = 500.0;  
float dx;  
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
  theta1 += 0.05;
  float x1 = theta1;
  for (int i = 0; i < yvalues1.length; i++) {
    yvalues1[i] = sin(x1)*amplitude;
    x1+=dx;
  }
}

void calcWave_2() {
  theta2 += 0.10;
  float x2 = theta2;
  for (int i = 0; i < yvalues2.length; i++) {
    yvalues2[i] = sin(x2)*amplitude;
    x2+=dx;
  }
}

void calcWave_3() {
  theta3 += 0.15;
  float x3 = theta3;
  for (int i = 0; i < yvalues3.length; i++) {
    yvalues3[i] = sin(x3)*amplitude;
    x3+=dx;
  }
}



void renderWave() {
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues1.length; x++) {
    stroke(255,155,55,100);    
    line(0,height/2,x*xspacing,250+yvalues1[x]);
  }
  for (int y = 0; y < yvalues2.length; y++) {
    stroke(155,255,55,100);    
    line(0,height/2,y*xspacing,500+yvalues2[y]);
  }
  for (int z = 0; z < yvalues3.length; z++) {
    stroke(155,55,255,100);    
    line(0,height/2,z*xspacing,750+yvalues3[z]);
  }
 
  
}

void mousePressed() {
  saveFrame("v5-##.jpg");
}
