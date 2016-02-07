// IMPORTS
import controlP5.*;

// DECLARATIONS
ControlP5 controlP5;
ControlP5 controlP5_2;
//ControlGroup[] e;
DropdownList[] dd;
Bang[] ps;
Numberbox nSec,nMin;
Bang savePreset;
ControlTimer counter1,counter2;

// VARIABLES
int randomSec = 1; // random preset change
int rSec,rMin;
Toggle checkbox,globalStrokeOn,hideEffekt,soundStroke;

int[] sortIndex;
float[] tmpIndex;

int GUIPosY,GUIPosX;
int TabsPosY,TabsPosX;
int prevBarX,prevBarY;
int groupWidth = 400;

// INIT
void initGUI() {
  controlP5_2 = new ControlP5(this);
  controlP5 = new ControlP5(this);
  dd = new DropdownList[cons.length];
  sortIndex = new int[cons.length];
  tmpIndex = new float[cons.length];
  controlP5.setAutoInitialization(true);


  GUIPosY = 230;
  GUIPosX = 25;
  TabsPosY = 330;
  TabsPosX = 25;
  prevBarX = GUIPosX+2;
  prevBarY = 210;

  // init effect menus
  initE1GUI();
  initE2GUI();
  initE3GUI();
  initE4GUI();
  initE5GUI();
  initE6GUI();
  initE7GUI();
 

  // define colors
  controlP5.setColorBackground(color(30));
  controlP5.setColorForeground(color(60));
  controlP5_2.setColorBackground(color(30));
  controlP5_2.setColorForeground(color(60));

  //effect Tabs ---------------
  controlP5.window().setPositionOfTabs(GUIPosX,301);
  controlP5.tab("default").setLabel("Sound Control");
  controlP5.tab("default").setHeight(20);
  controlP5.tab("default").setWidth(80);
  controlP5.tab("default").captionLabel().style().marginTop = 1;
  controlP5.tab("default").captionLabel().style().marginLeft = 3;
  controlP5.tab("default").captionLabel().style().marginTop = 1;
  controlP5.tab("default").captionLabel().style().marginLeft = 3;

  for (int i = 0; i < effectNumber; i++) {
    controlP5.tab(""+i).setLabel("Effect_"+(i+1));
    controlP5.tab(""+i).setHeight(20);
    controlP5.tab(""+i).setWidth(60);
    controlP5.tab(""+i).captionLabel().style().marginTop = 1;
    controlP5.tab(""+i).captionLabel().style().marginLeft = 3;
  }

  // Preset Buttons
  ps = new Bang[11];

  for (int i = 0; i < ps.length; i++) {
    ps[i] = controlP5.addBang("preset"+i,GUIPosX+i*63,30,62,20);
    ps[i].setLabel("Preset "+i);
    ps[i].moveTo("global");
  }

  //remove last bang to offscreen // bug ?
  ps[10].setPosition(-1000,-1000);

  // Save Button
  savePreset = controlP5.addBang("savePreset", width-25-62, GUIPosY+18, 62, 15);

  savePreset.captionLabel().style().marginTop = -15;
  savePreset.captionLabel().style().marginLeft = 4;
  savePreset.setLabel("Save Preset");
  savePreset.moveTo("global");


  // counter
  counter1 = new ControlTimer();
  counter2 = new ControlTimer();


  //random time numberbox
  nMin = controlP5_2.addNumberbox("nMin",0,110,GUIPosY+38,30,15);
  nMin.setMin(0);
  nMin.setLabel("MIN");
  nMin.setMax(999);
  nMin.captionLabel().style().marginTop = -15;
  nMin.captionLabel().style().marginLeft = 35;
  nMin.moveTo("global");

  nSec = controlP5_2.addNumberbox("nSec",1,165,GUIPosY+38,30,15);
  nSec.setMin(0);
  nSec.setLabel("Sec");
  nSec.setMax(59);
  nSec.captionLabel().style().marginTop = -15;
  nSec.captionLabel().style().marginLeft = 35;
  nSec.moveTo("global");


  //random change checkbox
  checkbox = controlP5_2.addToggle("Random Preset",false,110,GUIPosY+19,12,12);
  checkbox.captionLabel().style().marginTop = -15;
  checkbox.captionLabel().style().marginLeft = 20;
  checkbox.moveTo("global");

  //global stroke effekt
  globalStrokeOn = controlP5_2.addToggle("Stroke",false,225,GUIPosY+19,12,12);
  globalStrokeOn.captionLabel().style().marginTop = -15;
  globalStrokeOn.captionLabel().style().marginLeft = 20;
  globalStrokeOn.moveTo("global");

  //hide effekts on projector
  hideEffekt = controlP5_2.addToggle("Hide",false,290,GUIPosY+19,12,12);
  hideEffekt.captionLabel().style().marginTop = -15;
  hideEffekt.captionLabel().style().marginLeft = 20;
  hideEffekt.moveTo("global");

  //hide effekts on projector
  soundStroke = controlP5_2.addToggle("Reactive",false,225,GUIPosY+39,12,12);
  soundStroke.captionLabel().style().marginTop = -15;
  soundStroke.captionLabel().style().marginLeft = 20;
  soundStroke.moveTo("global");





  //Container Dropdown -----------
  for (int i = 0; i < dd.length; i++) {
    dd[i] = controlP5.addDropdownList("dd"+i,int(GUIPosX+i*(prevBarWidth+5)),GUIPosY,(int)prevBarWidth+4,100);
    dd[i].setBarHeight(15);
    dd[i].captionLabel().set(1+" ");
    dd[i].captionLabel().style().marginTop = 3;
    dd[i].captionLabel().style().marginLeft = 3;
    dd[i].moveTo("global");
    for(int j=0;j<effectNumber+1;j++) {
      dd[i].addItem(1+j+"",j);
    }
  }
} // init end

// TIMER
void nSec(int s) {
  rSec = s;
  randomSec = rSec + rMin *60;
}

void nMin(int m) {
  rMin = m;
  randomSec = rSec + rMin *60;
}

// SAVE PRESET
void savePreset() {
  controlP5.saveProperties("preset"+activePreset+".properties");
}

int activePreset ;

// PRESETS
void preset1() {
  activePreset = 1;
  counter2.reset();
  controlP5.loadProperties("preset1.properties");

  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[1].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset2() {
  activePreset = 2;
  counter2.reset();
  controlP5.loadProperties("preset2.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[2].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset3() {
  activePreset = 3;
  counter2.reset();
  controlP5.loadProperties("preset3.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[3].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset4() {
  activePreset = 4;
  counter2.reset();
  controlP5.loadProperties("preset4.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[4].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset5() {
  activePreset = 5;
  counter2.reset();
  controlP5.loadProperties("preset5.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[5].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset6() {
  activePreset = 6;
  counter2.reset();
  controlP5.loadProperties("preset6.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[6].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset7() {
  activePreset = 7;
  counter2.reset();
  controlP5.loadProperties("preset7.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[7].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset8() {
  activePreset = 8;
  counter2.reset();
  controlP5.loadProperties("preset8.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[8].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset9() {
  activePreset = 9;
  counter2.reset();
  controlP5.loadProperties("preset9.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[9].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
void preset0() {
  activePreset = 0;
  counter2.reset();
  controlP5.loadProperties("preset0.properties");
  for(int i = 0; i < ps.length; i++)ps[i].setColorForeground(60); 
  ps[0].setColorForeground(160);

  for(int i = 0; i < cons.length; i++) cons[i].mirrorX =false;
}
//Not sure why needed 
void preset10() {
  activePreset = 10;
}

