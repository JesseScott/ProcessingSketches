// IMPORTS
import processing.opengl.*;
import codeanticode.glgraphics.*;

// DECLARATIONS
GLGraphicsOffScreen winGraphics; 
GLGraphicsOffScreen[] pg; 
GLTextureWindow win;

// VARIABLES
String[] llines;
boolean debug = false;
boolean drawGUI = true;
boolean perspectiveMode = true;

float prevBarWidth = 22;
int effectNumber = 8;

PFont font;
float globalRandom;
Container[] cons ; // array of containers for graphics windows

int editNum = 0;
int projectorWidth = 1024; // width of 2nd screen
int projectorHeight =768; // height of 2nd screen
int tmpWidth;
int tmpHeight;

// SETUP
void setup () { 
  //Screen
  size(int(projectorWidth),int(projectorHeight),GLConstants.GLGRAPHICS);
  font = createFont("Kyrou 9 Regular.ttf",9,false);
  textFont(font);

  // Containers
  llines = loadStrings("pos.txt");
  cons = new Container[llines.length];
  pg = new GLGraphicsOffScreen[llines.length];
 
  for (int i = 0; i < cons.length; i++) {
    String[] pieces = split(llines[i], ';');
    cons[i] = new Container(Integer.parseInt(pieces[0]),Integer.parseInt(pieces[1]),Integer.parseInt(pieces[2]),Integer.parseInt(pieces[3]),
    Integer.parseInt(pieces[4]),Integer.parseInt(pieces[5]),Integer.parseInt(pieces[6]),Integer.parseInt(pieces[7]),Integer.parseInt(pieces[8]),
    Integer.parseInt(pieces[9]),Integer.parseInt(pieces[10]),Integer.parseInt(pieces[11]),i);

    int w = Integer.parseInt(pieces[10]);
    int h = Integer.parseInt(pieces[11]);
    pg[i] = new GLGraphicsOffScreen(this,w, h);
  }

  // Init Minim and ControlP5
  initMinim();
  initGUI();
  preset0();

  //Create Second Window
  win = new GLTextureWindow( this, screenWidth/2, 0, projectorWidth, projectorHeight); // 400x400 big at location 100,100
  winGraphics = new GLGraphicsOffScreen( this,projectorWidth, projectorHeight );
  win.setTexture( winGraphics.getTexture() );
} 

// DRAW
void draw() {
  background(0);
  globalRandom = random(9999);
  //println(frameRate);
  // println(activePreset);

  fill(255,0,0);

  for (int i = 0; i < cons.length; i++) {
    if(int(dd[i].value())==0)
      effect01(i);
    else if(int(dd[i].value())==1)
      effect02(i);
    else if(int(dd[i].value())==2)
      effect03(i);
    else if(int(dd[i].value())==3)
      effect04(i);
    else if(int(dd[i].value())==4)
      effect05(i);
    else if(int(dd[i].value())==5)
      effect06(i);
    else if(int(dd[i].value())==6)
      effect07(i);
  }

  winGraphics.beginDraw();
  winGraphics.background(0);

  textFont(font);

  for (int i = 0; i < cons.length; i++) {
    cons[i].render();
    if(debug && !drawGUI && perspectiveMode) cons[i].drag();
    if(debug && !drawGUI && !perspectiveMode) cons[i].drag2();
  }
  winGraphics.endDraw();


  //tmpWidth = int(float(height)/projectorHeight*projectorWidth);
  //tmpHeight = height;

  tmpHeight = int(float(width)/projectorWidth*projectorHeight);
  tmpWidth = width;

  if(!drawGUI)image(winGraphics.getTexture(), (width-tmpWidth)/2,height/2-tmpHeight/2,tmpWidth,tmpHeight);
  if(drawGUI)activeGUI();

  controlP5.draw();
  analyzeMinim();

  //belongs to effekt4
}

