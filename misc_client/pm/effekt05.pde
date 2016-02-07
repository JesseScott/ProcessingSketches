int e5_R = 110;
int e5_G = 0;
int e5_B = 0;

int e5_R2 = 128;
int e5_G2 = 128;
int e5_B2 = 128;

float e5_strokeW = 5;
int e5_spectrum = 10;
RadioButton e5_radio;

void initE5GUI() {


  controlP5.addSlider("e5_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e5_R").moveTo("4");
  controlP5.addSlider("e5_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e5_G").moveTo("4");
  controlP5.addSlider("e5_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e5_B").moveTo("4");

  controlP5.addSlider("e5_R2",00,255,128,TabsPosX,TabsPosY+100,100,10);
  controlP5.controller("e5_R2").moveTo("4");
  controlP5.addSlider("e5_G2",00,255,128,TabsPosX,TabsPosY+120,100,10);
  controlP5.controller("e5_G2").moveTo("4");
  controlP5.addSlider("e5_B2",00,255,128,TabsPosX,TabsPosY+140,100,10);
  controlP5.controller("e5_B2").moveTo("4");

  controlP5.addSlider("e5_strokeW",1,15,5,TabsPosX+150,TabsPosY+20,100,10);
  controlP5.controller("e5_strokeW").moveTo("4");

  controlP5.addSlider("e5_spectrum",1,50,5,TabsPosX+150,TabsPosY+40,100,10);
  controlP5.controller("e5_spectrum").moveTo("4");


  e5_radio = controlP5.addRadioButton("e5_radio",TabsPosX+150,TabsPosY+60);
  addToRadioButton(e5_radio,"LINE",1);
  addToRadioButton(e5_radio,"LINES",2);
  addToRadioButton(e5_radio,"CROSS",3);
  addToRadioButton(e5_radio,"BARS",4);
  e5_radio.setNoneSelectedAllowed(false);
  e5_radio.moveTo("4");
  e5_radio.setSpacingRow(10);
}



void effect05(int index) {
  pg[index].beginDraw();

  float pulse = map(in.mix.level(), 0, 0.75, 0, 255);

  pg[index].background(e5_R2,e5_G2,e5_B2);
  pg[index].noStroke();
  pg[index].stroke(pulse, pulse*2, pulse); // CONTROL -- COLOR PICKER/RANGE, + PULSE
  pg[index].strokeWeight(e5_strokeW); // CONTROL -- SLIDER
  
 

  pg[index].noFill();
  pg[index].stroke(e5_R,e5_G,e5_B);          
  pg[index].beginShape(); // CONTROL POINTS OR LINES -- TOGGLE
  for(int i = 0; i < in.bufferSize() - 1; i++) {

    if(e5_radio.getState(0))pg[index].vertex(cons[index].w/2+ in.mix.get(i)*fftSens,i*cons[index].h/e5_spectrum); // CONTROL *50 INTEGER -- SLIDER 
    if(e5_radio.getState(2))pg[index].ellipse(cons[index].w/2+ in.mix.get(i)*fftSens,i*cons[index].h/e5_spectrum,7,7);
    if(e5_radio.getState(3))pg[index].rect(cons[index].w/2-in.mix.get(i)*fftSens,i*cons[index].h/e5_spectrum,in.mix.get(i)*fftSens*2,4);
  } 
  pg[index].endShape();

  //    pg[index].noFill();
  //    pg[index].rect(0,0,cons[index].w,cons[index].h);

  pg[index].endDraw();
}

