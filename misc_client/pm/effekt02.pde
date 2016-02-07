int e2_R = 0;
int e2_G = 0;
int e2_B = 210;
int e2_R2 = 125;
int e2_G2 = 125;
int e2_B2 = 125;
int e2_boxHeight = 12;
float e2_strokeWeight = 1;
int e2_stroke = 0;
int e2_bg = 0;
RadioButton   e2_radio;
Toggle e2_t1,e2_t2;
float e2_val = 0;
void initE2GUI() {

  controlP5.addSlider("e2_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e2_R").moveTo("1");
  controlP5.addSlider("e2_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e2_G").moveTo("1");
  controlP5.addSlider("e2_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e2_B").moveTo("1");

  controlP5.addSlider("e2_R2",00,255,128,TabsPosX,TabsPosY+110,100,10);
  controlP5.controller("e2_R2").moveTo("1");
  controlP5.addSlider("e2_G2",00,255,128,TabsPosX,TabsPosY+130,100,10);
  controlP5.controller("e2_G2").moveTo("1");
  controlP5.addSlider("e2_B2",00,255,128,TabsPosX,TabsPosY+150,100,10);
  controlP5.controller("e2_B2").moveTo("1");

  controlP5.addSlider("e2_boxHeight",1,80,12,TabsPosX+150,TabsPosY+20,100,10);
  controlP5.controller("e2_boxHeight").moveTo("1");

  controlP5.addSlider("e2_strokeWeight",0,40,1,TabsPosX+150,TabsPosY+40,100,10);
  controlP5.controller("e2_strokeWeight").moveTo("1");

  controlP5.addSlider("e2_stroke",00,255,20,TabsPosX+150,TabsPosY+60,100,10);
  controlP5.controller("e2_stroke").moveTo("1");

  controlP5.addSlider("e2_bg",00,255,20,TabsPosX+150,TabsPosY+80,100,10);
  controlP5.controller("e2_bg").moveTo("1");

  e2_radio = controlP5.addRadioButton("e2_radio",TabsPosX+150,TabsPosY+100);
  addToRadioButton(e2_radio,"Mode1",1);
  addToRadioButton(e2_radio,"Mode2",2);
  addToRadioButton(e2_radio,"Mode3",3);
  addToRadioButton(e2_radio,"Mode4",4);
  e2_radio.setNoneSelectedAllowed(false);
  e2_radio.moveTo("1");
  e2_radio.setSpacingRow(10);

  e2_t1 = controlP5.addToggle("Fade",true,TabsPosX+250,TabsPosY+100,15,15);
  e2_t1.captionLabel().style().marginTop = -15;
  e2_t1.captionLabel().style().marginLeft = 20;
  e2_t1.moveTo("1");
  
  e2_t2 = controlP5.addToggle("MirrorX",true,TabsPosX+250,TabsPosY+120,15,15);
  e2_t2.captionLabel().style().marginTop = -15;
  e2_t2.captionLabel().style().marginLeft = 20;
  e2_t2.moveTo("1");
  
}

void effect02(int index) {
  pg[index].beginDraw();


  pg[index].noStroke();
  pg[index].fill(e2_bg,4);
  pg[index].rect(-5,-5,cons[index].w+10,cons[index].h+10);
  pg[index].stroke(e2_stroke);
  pg[index].strokeWeight(e2_strokeWeight); 

  int boxCount = cons[index].h/e2_boxHeight;

  for (int i = 0; i <= boxCount; i++) {
    // pg[index].fill(255,60*index,0); 


    if(e2_radio.getState(0)) {

      if(!e2_t1.getState())pg[index].fill(e2_bg );
      if(i+1 >=abs(sin(frameCount/15.0+index )) *(boxCount+2))
        pg[index].fill(lerpColor(color(e2_R,e2_G,e2_B),color(e2_R2,e2_G2,e2_B2),1.0/boxCount*i));
      pg[index].rect(0,i*e2_boxHeight,cons[index].w,e2_boxHeight);
    }

    if(e2_radio.getState(1)) {
      pg[index].fill(lerpColor(color(e2_R,e2_G,e2_B),color(e2_R2,e2_G2,e2_B2),constrain(abs(in.mix.get(i)*fftSens),0,1)));   
      pg[index].rect(0,i*e2_boxHeight,cons[index].w,e2_boxHeight);
    }
    if(e2_radio.getState(2)) {
      if(!e2_t1.getState())pg[index].fill(e2_bg );
      if(boxCount-(i-1) <=  abs(in.mix.get(index)*fftSens) *(boxCount+2))
        pg[index].fill(lerpColor(color(e2_R,e2_G,e2_B),color(e2_R2,e2_G2,e2_B2),1.0/boxCount*i));
     
      pg[index].rect(0,i*e2_boxHeight,cons[index].w,e2_boxHeight);
    }

    if(e2_radio.getState(3)) {
      if(!e2_t1.getState())pg[index].fill(e2_bg );
      if(frameCount%2==0)e2_val = abs(in.mix.get(index)*fftSens) *(boxCount+2);
      if(i+1 ==int(e2_val))
        pg[index].fill(lerpColor(color(e2_R,e2_G,e2_B),color(e2_R2,e2_G2,e2_B2),1.0/boxCount*i));
      if(i+1 ==int(e2_val) || !e2_t1.getState() )pg[index].rect(0,i*e2_boxHeight,cons[index].w,e2_boxHeight);
    }
  }
  pg[index].endDraw();

  cons[index].mirrorX = e2_t2.getState();
}

