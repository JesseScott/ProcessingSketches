int e4_R = 110;
int e4_G = 0;
int e4_B = 0;

int e4_R2 = 128;
int e4_G2 = 128;
int e4_B2 = 128;

int e4_R3 = 128;
int e4_G3 = 128;
int e4_B3 = 128;

int e4_speed = 4;
float e4_speed2 = 2;

int e4_r = 0;
Toggle e4_t1,e4_t2,e4_t3,e4_t4,e4_t5;


void initE4GUI() {

  controlP5.addSlider("e4_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e4_R").moveTo("3");
  controlP5.addSlider("e4_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e4_G").moveTo("3");
  controlP5.addSlider("e4_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e4_B").moveTo("3");

  controlP5.addSlider("e4_R2",00,255,128,TabsPosX,TabsPosY+110,100,10);
  controlP5.controller("e4_R2").moveTo("3");
  controlP5.addSlider("e4_G2",00,255,128,TabsPosX,TabsPosY+130,100,10);
  controlP5.controller("e4_G2").moveTo("3");
  controlP5.addSlider("e4_B2",00,255,128,TabsPosX,TabsPosY+150,100,10);
  controlP5.controller("e4_B2").moveTo("3");

  controlP5.addSlider("e4_R3",00,255,128,TabsPosX+150,TabsPosY+20,100,10);
  controlP5.controller("e4_R3").moveTo("3");
  controlP5.addSlider("e4_G3",00,255,128,TabsPosX+150,TabsPosY+40,100,10);
  controlP5.controller("e4_G3").moveTo("3");
  controlP5.addSlider("e4_B3",00,255,128,TabsPosX+150,TabsPosY+60,100,10);
  controlP5.controller("e4_B3").moveTo("3");

  e4_t1 = controlP5.addToggle("autoColor Bars",false,TabsPosX,TabsPosY+80,15,15);
  e4_t1.captionLabel().style().marginTop = -15;
  e4_t1.captionLabel().style().marginLeft = 20;
  e4_t1.moveTo("3");

  e4_t2 = controlP5.addToggle("Double Bars",false,TabsPosX+150,TabsPosY+80,15,15);
  e4_t2.captionLabel().style().marginTop = -15;
  e4_t2.captionLabel().style().marginLeft = 20;
  e4_t2.moveTo("3");

  e4_t3 = controlP5.addToggle("Reverse",false,TabsPosX+240,TabsPosY+80,15,15);
  e4_t3.captionLabel().style().marginTop = -15;
  e4_t3.captionLabel().style().marginLeft = 20;
  e4_t3.moveTo("3");

  e4_t4 = controlP5.addToggle("Random",false,TabsPosX+150,TabsPosY+150,15,15);
  e4_t4.captionLabel().style().marginTop = -15;
  e4_t4.captionLabel().style().marginLeft = 20;
  e4_t4.moveTo("3");

  e4_t5 = controlP5.addToggle("On Beat",false,TabsPosX+190,TabsPosY+150,15,15);
  e4_t5.captionLabel().style().marginTop = -15;
  e4_t5.captionLabel().style().marginLeft = 20;
  e4_t5.moveTo("3");

  controlP5.addSlider("e4_speed",0,20,10,TabsPosX+150,TabsPosY+130,100,10);
  controlP5.controller("e4_speed").moveTo("3");

  controlP5.addSlider("e4_speed2",0,20,10,TabsPosX+150,TabsPosY+110,100,10);
  controlP5.controller("e4_speed2").moveTo("3");
}

void effect04(int index) {

  pg[index].beginDraw();
  pg[index].background(0);
  pg[index].noStroke();


  pg[index].fill( e4_R3,e4_G3,e4_B3);
  pg[index].rect(0,0,cons[index].w,cons[index].h);

 pg[index].fill( lerpColor(color(e4_R,e4_G,e4_B),color(e4_R3,e4_G3,e4_B3),(sin( frameCount/e4_speed2 )+1)/2.0 ));


  int boxSize = 10;

  int tmpIndex = 0;
  int tmpIndex2 = 0;
  int tmpIndex_2 = 0;
  int tmpIndex2_2 = 0; 
  if( e4_speed!=0) {
    tmpIndex = sortIndex[int(frameCount/e4_speed%cons.length/2)];
    tmpIndex2 = sortIndex[cons.length-1-int(frameCount/e4_speed% cons.length/2)];

    tmpIndex_2=100;
    tmpIndex2_2=100;
  }

  if(e4_t3.getState() && e4_speed!=0) {
    tmpIndex = sortIndex[cons.length/2-int(frameCount/e4_speed%cons.length/2)-1];
    tmpIndex2 = sortIndex[cons.length/2+int(frameCount/e4_speed%cons.length/2)];
  }


  if(e4_t2.getState() && e4_speed!=0) { 
    tmpIndex = sortIndex[int(frameCount/e4_speed% cons.length/4)*2];
    tmpIndex2 = sortIndex[cons.length-1-int(frameCount/e4_speed% cons.length/4)*2];
    tmpIndex_2 = sortIndex[1+int(frameCount/e4_speed% cons.length/4)*2];
    tmpIndex2_2 = sortIndex[cons.length-2-int(frameCount/e4_speed% cons.length/4)*2];
  }


  if(e4_t3.getState() && e4_t2.getState() && e4_speed!=0) {
    tmpIndex = sortIndex[(cons.length/2-int(frameCount/e4_speed% cons.length/4)*2)-1]; //
    tmpIndex2 = sortIndex[cons.length/2+( int(frameCount/e4_speed% cons.length/4)*2)];

    tmpIndex_2 = sortIndex[(cons.length/2-int(frameCount/e4_speed% cons.length/4)*2)]; //
    tmpIndex2_2 = sortIndex[cons.length/2-1+( int(frameCount/e4_speed% cons.length/4)*2)];
  }


  if(!e4_t5.getState() &&(frameCount%(e4_speed+1))==0)e4_r=int(globalRandom);
  if(e4_t5.getState() && beat.isHat()) e4_r=int(globalRandom);
  if(e4_t4.getState() && e4_speed!=0) {
    tmpIndex = sortIndex[int(e4_r%cons.length/2)*2];
    tmpIndex2 = 999;
    tmpIndex_2 = sortIndex[1+int(e4_r%cons.length/2)*2];
    tmpIndex2_2 = 999;
  }

  //  if(false){r = int(random(cons.length/2)); 
  //  tmpIndex = sortIndex[r];
  //  tmpIndex2 = sortIndex[cons.length-1-r];
  //  }

  if(index == tmpIndex   ||   index == tmpIndex2   ||  index == tmpIndex_2   ||   index == tmpIndex2_2 ) {
    if(e4_speed != 0) {
      pg[index].fill( e4_R2,e4_G2,e4_B2);
      if(e4_t1.getState())pg[index].fill( e4_G,e4_B,e4_R);
    }
  }


  pg[index].rect(0,0,cons[index].w,cons[index].h);
  pg[index].endDraw();
}

