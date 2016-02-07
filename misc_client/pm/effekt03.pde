
int e3_R = 128;
int e3_G = 128;
int e3_B = 128;
int e3_R2 = 128;
int e3_G2 = 128;
int e3_B2 = 128;

float e3_stepSize = 4;
RadioButton e3_radio;
RadioButton e3_radio2;
Toggle e3_t1,e3_t2,e3_t3;


void initE3GUI() {
  controlP5.addSlider("e3_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e3_R").moveTo("2");
  controlP5.addSlider("e3_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e3_G").moveTo("2");
  controlP5.addSlider("e3_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e3_B").moveTo("2");

  controlP5.addSlider("e3_R2",00,255,128,TabsPosX,TabsPosY+110,100,10);
  controlP5.controller("e3_R2").moveTo("2");
  controlP5.addSlider("e3_G2",00,255,128,TabsPosX,TabsPosY+130,100,10);
  controlP5.controller("e3_G2").moveTo("2");
  controlP5.addSlider("e3_B2",00,255,128,TabsPosX,TabsPosY+150,100,10);
  controlP5.controller("e3_B2").moveTo("2");

  controlP5.addSlider("e3_stepSize",1,50,4,TabsPosX+150,TabsPosY+20,100,10);
  controlP5.controller("e3_stepSize").moveTo("2");

  e3_t1 = controlP5.addToggle("Single",true,TabsPosX,TabsPosY+80,15,15);
  e3_t1.captionLabel().style().marginTop = -15;
  e3_t1.captionLabel().style().marginLeft = 20;
  e3_t1.moveTo("2");

  e3_t2 = controlP5.addToggle("Mirror",false,TabsPosX+60,TabsPosY+80,15,15);
  e3_t2.captionLabel().style().marginTop = -15;
  e3_t2.captionLabel().style().marginLeft = 20;
  e3_t2.moveTo("2");

  e3_radio = controlP5.addRadioButton("e3_radio",TabsPosX+150,TabsPosY+60);
  addToRadioButton(e3_radio,"ColorMode1",1);
  addToRadioButton(e3_radio,"ColorMode2",2);
  addToRadioButton(e3_radio,"ColorMode3",3);
  addToRadioButton(e3_radio,"ColorMode4",4);
  e3_radio.setNoneSelectedAllowed(false);
  e3_radio.moveTo("2");
  e3_radio.setSpacingRow(10);

  e3_radio2 = controlP5.addRadioButton("e3_radio2",TabsPosX+250,TabsPosY+60);
  addToRadioButton(e3_radio2,"Kick",1);
  addToRadioButton(e3_radio2,"Snare",2);
  addToRadioButton(e3_radio2,"Hat",3);
  addToRadioButton(e3_radio2,"Volume",4);
  e3_radio2.setNoneSelectedAllowed(false);  
  e3_radio2.moveTo("2");
  e3_radio2.setSpacingRow(10);
}
void e3_radio(int i) {
  println(i);
}

void effect03( int index) {

  pg[index].beginDraw();
  pg[index].noStroke();


  color fromC = color(e3_R,e3_G,e3_B);
  color toC = color(e3_R2,e3_G2,e3_B2);

  pg[index].background(toC);


  float num = cons[index].h/ e3_stepSize ;
  pg[index].fill(255);
  // pg[index].stroke(255,0,0);
  if(e3_radio2.getState(0))  num = (kickSize*cons[index].h/e3_stepSize);
  if(e3_radio2.getState(1))  num = (snareSize*cons[index].h/e3_stepSize);
  if(e3_radio2.getState(2))  num = (hatSize*cons[index].h/e3_stepSize);
  if(e3_radio2.getState(3))  num = in.mix.level()* volumeSens; // more sense



  for(int i = 0; i < num; i++) {
    if(e3_radio.getState(0)) pg[index].fill(lerpColor(fromC,toC, (float(i*2)*.1)%1.0));
    if(e3_radio.getState(1)) pg[index].fill(lerpColor(fromC,toC,i/num));

    if(e3_radio.getState(2)) pg[index].fill(lerpColor(fromC,toC,i/num*sin(i)));
    if(e3_radio.getState(3)) pg[index].fill(fromC);

    if(e3_t2.getState())pg[index].rect(0,(cons[index].h- e3_stepSize /2*i)-cons[index].h/2,cons[index].w, e3_stepSize );
    if(e3_t2.getState())pg[index].rect(0,(cons[index].h- e3_stepSize /2*-i)-cons[index].h/2,cons[index].w, e3_stepSize );

    if(e3_t1.getState())pg[index].rect(0,cons[index].h- e3_stepSize *i,cons[index].w, e3_stepSize );
  }



  pg[index].endDraw();
} 


void addToRadioButton(RadioButton theRadioButton, String theName, int theValue ) {
  Toggle t = theRadioButton.addItem(theName,theValue);
  t.captionLabel().style().movePadding(2,0,-1,2);
  t.captionLabel().style().moveMargin(-2,0,0,-3);
  t.captionLabel().style().backgroundWidth = 46;
}

