int e6_R = 110;
int e6_G = 0;
int e6_B = 0;

int e6_R2 = 128;
int e6_G2 = 128;
int e6_B2 = 128;

float e6_speed = 5;
int e6_spectrum = 10;
float e6_posY = 0;
float e6_lineSpacing; 
float e6_offSet;
float e6_fontSize;
float e6_textLength;
RadioButton e6_radio;
PFont font2,font3,font4,font5;
String e6_txt = "onformative ";
Textfield e6_textfield;
Toggle e6_t1;
Toggle e6_t2;
Toggle e6_t3;
Toggle e6_t4;



void initE6GUI() {


  font2 = createFont("venus rising.ttf",80 );  
  font3 = createFont("TRANA___.TTF", 80 );  
  font4 = createFont("BULLBA__.TTF", 80 );  
  font5 = createFont("INVADERS.TTF",80, false );  



  controlP5.addSlider("e6_R",00,255,128,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("e6_R").moveTo("5");
  controlP5.addSlider("e6_G",00,255,128,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("e6_G").moveTo("5");
  controlP5.addSlider("e6_B",00,255,128,TabsPosX,TabsPosY+60,100,10);
  controlP5.controller("e6_B").moveTo("5");

  controlP5.addSlider("e6_R2",00,255,128,TabsPosX,TabsPosY+100,100,10);
  controlP5.controller("e6_R2").moveTo("5");
  controlP5.addSlider("e6_G2",00,255,128,TabsPosX,TabsPosY+120,100,10);
  controlP5.controller("e6_G2").moveTo("5");
  controlP5.addSlider("e6_B2",00,255,128,TabsPosX,TabsPosY+140,100,10);
  controlP5.controller("e6_B2").moveTo("5");

  controlP5.addSlider("e6_speed",-5,5,0,TabsPosX+150,TabsPosY+20,100,10);
  controlP5.controller("e6_speed").moveTo("5");

  controlP5.addSlider("e6_offSet",-150,150,00,TabsPosX+150,TabsPosY+40,100,10);
  controlP5.controller("e6_offSet").moveTo("5");

  controlP5.addSlider("e6_lineSpacing",0,100,25,TabsPosX+150,TabsPosY+60,100,10);
  controlP5.controller("e6_lineSpacing").moveTo("5");

  controlP5.addSlider("e6_fontSize",1,120,25,TabsPosX+150,TabsPosY+80,100,10);
  controlP5.controller("e6_fontSize").moveTo("5");

  e6_radio = controlP5.addRadioButton("e6_radio",TabsPosX+150,TabsPosY+100);
  addToRadioButton(e6_radio,"Text",1);
  addToRadioButton(e6_radio,"LCD",2);
  addToRadioButton(e6_radio,"BULLETS",3);
  addToRadioButton(e6_radio,"INVADERS",4);
  e6_radio.setNoneSelectedAllowed(false);
  e6_radio.moveTo("5");
  e6_radio.setSpacingRow(10);

  e6_textfield = controlP5.addTextfield("e6_txt",TabsPosX+350,TabsPosY+20,150,20);
  e6_textfield.setFocus(true);
  e6_textfield.moveTo("5");


  e6_t1 = controlP5.addToggle("Gradient",false,TabsPosX,TabsPosY+80,15,15);
  e6_t1.captionLabel().style().marginTop = -15;
  e6_t1.captionLabel().style().marginLeft = 20;
  e6_t1.moveTo("5");

  e6_t2 = controlP5.addToggle("random Color",false,TabsPosX+60,TabsPosY+80,15,15);
  e6_t2.captionLabel().style().marginTop = -15;
  e6_t2.captionLabel().style().marginLeft = 20;
  e6_t2.moveTo("5");

  e6_t3 = controlP5.addToggle("Beat on",false,TabsPosX+330,TabsPosY+80,15,15);
  e6_t3.captionLabel().style().marginTop = -15;
  e6_t3.captionLabel().style().marginLeft = 20;
  e6_t3.moveTo("5");

  e6_t4 = controlP5.addToggle("Fade",false,TabsPosX+390,TabsPosY+80,15,15);
  e6_t4.captionLabel().style().marginTop = -15;
  e6_t4.captionLabel().style().marginLeft = 20;
  e6_t4.moveTo("5");
}



void effect06(int index) {
  pg[index].beginDraw();


  float pulse = map(in.mix.level(), 0, 0.75, 1, 1.5);

  e6_textLength = e6_txt.length() *e6_lineSpacing;


  if(e6_t3.getState()) {
    if(e6_radio.getState(0))pg[index].textFont(font2,e6_fontSize *(1+hatSize/2 ));
    if(e6_radio.getState(1))pg[index].textFont(font3,e6_fontSize *(1+hatSize/2));
    if(e6_radio.getState(2))pg[index].textFont(font4,e6_fontSize *(1+hatSize/2));
    if(e6_radio.getState(3))pg[index].textFont(font5,e6_fontSize *(1+hatSize/2));
  }
  else {
    if(e6_radio.getState(0))pg[index].textFont(font2,e6_fontSize );
    if(e6_radio.getState(1))pg[index].textFont(font3,e6_fontSize );
    if(e6_radio.getState(2))pg[index].textFont(font4,e6_fontSize );
    if(e6_radio.getState(3))pg[index].textFont(font5,e6_fontSize );
  }



  if(!e6_t4.getState()) {
    pg[index].background(e6_R2,e6_G2,e6_B2);
  }
  else {
    pg[index].fill(e6_R2,e6_G2,e6_B2,60);
    pg[index].rect(-10,-10,200,200);
  }

  if(e6_t2.getState())pg[index].background(0);

  pg[index].noStroke();
  pg[index].fill(e6_R,e6_G,e6_B);          
  pg[index].textAlign(CENTER);


  if(e6_t1.getState())pg[index].colorMode(HSB,255);  

  for(int i = 1; i <= e6_txt .length(); i++) {
    if(e6_t1.getState())pg[index].fill(e6_R+(float(i)/e6_txt.length()*e6_G),255,255);

    if(e6_t2.getState()) {
      if(i%2==0)pg[index].fill(e6_R,e6_G,e6_B);
      if(i%2==1)pg[index].fill(e6_R2,e6_G2,e6_B2);
    }


    pg[index].text(e6_txt .substring(i-1,i), -cons[index].w*3,  -e6_textLength+e6_posY + (i-1) *e6_lineSpacing+e6_offSet,cons[index].w*7,cons[index].h );
  }

  for(int i = 1; i <= e6_txt .length(); i++) {
    if(e6_t1.getState())pg[index].fill(e6_R+(float(i)/e6_txt.length()*e6_G),255,255);

    if(e6_t2.getState()) {
      if(i%2==0)pg[index].fill(e6_R,e6_G,e6_B);
      if(i%2==1)pg[index].fill(e6_R2,e6_G2,e6_B2);
    }

    pg[index].text(e6_txt .substring(i-1,i), -cons[index].w*3,  e6_posY + (i-1) *e6_lineSpacing+e6_offSet,cons[index].w*7,cons[index].h );
  }

  for(int i = 1; i <= e6_txt .length(); i++) {
    if(e6_t1.getState())pg[index].fill(e6_R+(float(i)/e6_txt.length()*e6_G),255,255);

    if(e6_t2.getState()) {
      if(i%2==0)pg[index].fill(e6_R,e6_G,e6_B);
      if(i%2==1)pg[index].fill(e6_R2,e6_G2,e6_B2);
    }

    pg[index].text(e6_txt .substring(i-1,i), -cons[index].w*3,  e6_textLength+e6_posY + (i-1) *e6_lineSpacing+e6_offSet,cons[index].w*7,cons[index].h );
  }

  if(e6_t1.getState())pg[index].colorMode(RGB,255,255,255,255);

  // Test ellipse
  //  pg[index].fill(255,0,0); 
  //  pg[index].ellipse(20,e6_posY,5,5); 
  e6_posY-= e6_speed ;

  if(e6_posY <= -e6_textLength && e6_speed > 0 )e6_posY =  e6_textLength;
  if(e6_posY >= e6_textLength  && e6_speed < 0 )e6_posY =  -e6_textLength ;


  pg[index].endDraw();
  
 
}

