int e7_R = 110;
int e7_G = 0;
int e7_B = 0;

int e7_R2 = 128;
int e7_G2 = 128;
int e7_B2 = 128;

float e7_speed = 5;
int e7_gridSize =  5;
Toggle e7_t1,e7_t2,e7_t3;
float xoff = 0.0;
float yoff = 1.0;
int tileCountX = 15;
int tileCountY = 40;
int currentTileCountX;
int currentTileCountY;
Bang randomC1;
Bang randomC2;
Bang randomC3;

void initE7GUI() {


  controlP5.addSlider("currentTileCountX",1,tileCountX,4,TabsPosX,TabsPosY+20,100,10);
  controlP5.controller("currentTileCountX").moveTo("6");
  controlP5.addSlider("currentTileCountY",1,tileCountY,4,TabsPosX,TabsPosY+40,100,10);
  controlP5.controller("currentTileCountY").moveTo("6");


  controlP5.addSlider("e7_speed",1,50,1,TabsPosX+200,TabsPosY+20,100,10);
  controlP5.controller("e7_speed").moveTo("6");

  controlP5.addSlider("e7_gridSize",2,20,10,TabsPosX+200,TabsPosY+40,100,10);
  controlP5.controller("e7_gridSize").moveTo("6");


  e7_t1 = controlP5.addToggle("Show Grid",false,TabsPosX,TabsPosY+80,15,15);
  e7_t1.captionLabel().style().marginTop = -15;
  e7_t1.captionLabel().style().marginLeft = 20;
  e7_t1.moveTo("6");


  randomC1 = controlP5.addBang("randomC1",TabsPosX+100,TabsPosY+80,62,15);
  randomC1.captionLabel().style().marginTop = -15;
  randomC1.captionLabel().style().marginLeft = 4;
  randomC1.setLabel("randomC1");
  randomC1.moveTo("6");

  randomC2 = controlP5.addBang("randomC2",TabsPosX+100,TabsPosY+100,62,15);
  randomC2.captionLabel().style().marginTop = -15;
  randomC2.captionLabel().style().marginLeft = 4;
  randomC2.setLabel("randomC2");
  randomC2.moveTo("6");

  randomC3 = controlP5.addBang("randomC3",TabsPosX+100,TabsPosY+120,62,15);
  randomC3.captionLabel().style().marginTop = -15;
  randomC3.captionLabel().style().marginLeft = 4;
  randomC3.setLabel("randomC3");
  randomC3.moveTo("6");

//
//  e7_t3 = controlP5.addToggle("Mirror Right",true,TabsPosX+250,TabsPosY+100,15,15);
//  e7_t3.captionLabel().style().marginTop = -15;
//  e7_t3.captionLabel().style().marginLeft = 20;
//  e7_t3.moveTo("6");
//
//  e7_t2 = controlP5.addToggle("Mirror Left",true,TabsPosX+250,TabsPosY+120,15,15);
//  e7_t2.captionLabel().style().marginTop = -15;
//  e7_t2.captionLabel().style().marginLeft = 20;
//  e7_t2.moveTo("6");




  for (int i=0; i<tileCountX; i++) {
    hueValues[i] = (int) random(0,360);
    saturationValues[i] = (int) random(0,100);
    brightnessValues[i] = (int) random(0,100);
  }
}







// arrays for color components values
int[] hueValues = new int[tileCountX];
int[] saturationValues = new int[tileCountX];
int[] brightnessValues = new int[tileCountX];


void effect07(int index) {



  pg[index].beginDraw();
  pg[index].noStroke();
  pg[index].colorMode(HSB,360,100,100,100);


  int counter = 0;

  // map mouse to grid resolution

  float tileWidth = cons[index].w / (float) currentTileCountX;
  float tileHeight = cons[index].h / (float) currentTileCountY;
  counter+=(frameCount/10.0)* e7_speed ;
 

    for (int gridY=0; gridY< tileCountY; gridY++) {
      for (int gridX=0; gridX< tileCountX; gridX++) {  

        //   brightnessValues[gridY]  =  ( brightnessValues[gridY]+1)%100 ;
        float posX = tileWidth*gridX;
        float posY = tileHeight*gridY;
        int index2 = counter % (currentTileCountX);

        // get component color values
        pg[index].fill(hueValues[(index2 ) ],saturationValues[index2],brightnessValues[index2]);
        pg[index].rect(posX, posY, tileWidth, tileHeight);
        counter++;
      }
    }
   


  if( e7_t1.getState()) {
    for (int i=0; i< cons[index].h; i+= e7_gridSize) {
      pg[index].fill(0);
      pg[index].rect(0,i, cons[index].w,  e7_gridSize/2.0);
    }
  }




  pg[index].colorMode(RGB,255,255,255,255);
  pg[index].endDraw();
 

}



void randomC1() {

  for (int i=0; i<tileCountX; i++) {
    if (i%2 == 0) {
      hueValues[i] = (int) random(0,360);
      saturationValues[i] = 100;
      brightnessValues[i] = (int) random(0,100);
    } 
    else {
      hueValues[i] = 195;
      saturationValues[i] = (int) random(0,100);
      brightnessValues[i] = 100;
    }
  }
}



void randomC2() {
  int tt = int(random(360));
  for (int i=0; i<tileCountX; i++) {
    hueValues[i] = int(random(tt-10,tt));
    saturationValues[i] = 100;
    brightnessValues[i] = (int) random(0,100);
  }
}



void randomC3() {
  for (int i=0; i<tileCountX; i++) {
    hueValues[i] = (int) random(0,360);
    saturationValues[i] = (int) random(0,100);
    brightnessValues[i] = (int) random(0,100);
  }
}

