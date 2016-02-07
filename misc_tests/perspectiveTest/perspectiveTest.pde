String[] llines;
boolean debug = true;
boolean drawGUI = true;
boolean perspectiveMode = false;

Container[] cons ;
PGraphics[] pg;

// ---------------

void setup () { 
  size(1280,720, P3D); 
  
  smooth();
  // llines = loadStrings("pos.txt");
  int[] llines = new int[9];
  llines[1] = 495;
  llines[2] = 201;
  llines[3] = 663;
  llines[4] = 194;
  llines[5] = 667;
  llines[6] = 468;
  llines[7] = 566;
  llines[8] = 42;
  llines[9] = 60;
  
  cons = new Container[llines.length];
  pg = new PGraphics[llines.length];
  for (int i = 0; i < cons.length; i++) {
    String[] pieces = split(llines[i], ';');
    cons[i] = new Container(Integer.parseInt(pieces[0]),Integer.parseInt(pieces[1]),Integer.parseInt(pieces[2]),Integer.parseInt(pieces[3]),Integer.parseInt(pieces[4]),Integer.parseInt(pieces[5]),Integer.parseInt(pieces[6]),Integer.parseInt(pieces[7]),Integer.parseInt(pieces[8]),Integer.parseInt(pieces[9]),i);

    int w = Integer.parseInt(pieces[8]);
    int h = Integer.parseInt(pieces[9]);
    pg[i] = createGraphics(w, h, JAVA2D);
  }
  
  
}

// ---------------

void draw() {
  background(0);
  
  
  
}

// ---------------

void keyPressed() {
  if(key=='d')debug =!debug;
  if(key=='p')perspectiveMode =!perspectiveMode;
  //saving positions
  if(key=='s') {
    String[] lines = new String[cons.length];
    for (int i = 0; i < cons.length; i++) {
      lines[i] =  (int)cons[i].v[0].x + ";" + (int)cons[i].v[0].y  + ";" +(int)cons[i].v[1].x + ";" + (int)cons[i].v[1].y  + ";" +(int)cons[i].v[2].x + ";" + (int)cons[i].v[2].y  + ";" +(int)cons[i].v[3].x + ";" + (int)cons[i].v[3].y  + ";" + cons[i].w  + ";" + cons[i].h  ;
    }
    saveStrings("pos.txt", lines);
  }

  if(key=='m')drawGUI =!drawGUI;
  //if(!drawGUI)controlP5.hide();
  // if(drawGUI)controlP5.show();
}

// ---------------

void effect01(int index) {
  pg[index].beginDraw();
  pg[index].background(0);
  pg[index].noStroke();
  pg[index].fill(255,120*index,0);

  int boxSize = 10;

  for (int i = 0; i < cons[index].h/boxSize; i++) {
  pg[index].fill(255,60*index,0); 
  if(i<abs(sin(frameCount/20.0)*cons[index].h/boxSize))pg[index].fill(40);
  pg[index].rect(0,i*boxSize-1,cons[index].w,boxSize-1); 
    
  }

  pg[index].stroke(255);
  pg[index].noFill();
  pg[index].rect(0,0,cons[index].w-1,cons[index].h-1);
 
  pg[index].endDraw();
 
}

// ---------------

void initGraphics() {
  for (int i = 0; i < 3; i++) {
    pg[i] = createGraphics(cons[i].w, cons[i].h, P3D);
  }
}

// ---------------

class Container {
  PVector[] v = new PVector[4];
  int handleSize = 10;
  boolean drag = false;

  int index;
  int w,h;



  Container(float x0, float y0,float x1, float y1,float x2, float y2,float x3, float y3,int _w, int _h, int _index) {


    v[0] = new PVector(x0, y0);
    v[1] = new PVector(x1, y1);
    v[2] = new PVector(x2, y2);
    v[3] = new PVector(x3, y3);
    w = _w;
    h = _h;
    index = _index;
  }
}
