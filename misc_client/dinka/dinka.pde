
// IMPORTS
// ________________________
import processing.video.*;


// DECLARATIONS
// ________________________

MovieMaker mm;
String lines[];
Symbol[] symbol, newsymbol;
PImage[] images;

// VARIABLES
// ________________________

int count = 0;
boolean added = false;
PImage newImg;

// SETUP
// ________________________

void setup() {
  size(screenWidth, screenHeight, P3D);
  background(0);
  frameRate(30);
  
  // MovieMaker
  mm = new MovieMaker(this, width, height, "export.mov", 30, MovieMaker.MOTION_JPEG_A, MovieMaker.HIGH);

  // Text File
  lines = loadStrings("symbolNames.txt");
  println("There are " + lines.length + " lines..."); 
  
  // Image Array
  PImage[] images = new PImage[lines.length];
  
  // Object Array
  symbol = new Symbol[lines.length];
  
  for(int i = 1; i < lines.length; i++) {
    
    // Load Images
    images[i] = loadImage(lines[i]); 
    //println("Loaded " + i + " Pictures");
    
    // Create Objects
    int evenodd;
    if(i % 2 == 1) {
      evenodd = -1;
    }
    else {
      evenodd = 1; 
    }
    symbol[i] = new Symbol( (width/2) -100 + ((i * 7) * evenodd), random(-height, -100), 0, random(5.0, 10.0), 
      // XPOS  YPOS  ZPOS  GRAVITY  
    random(1, 360), random(1, 360), random(0, 360));
      // ROTX  ROTY  ROTZ  
    symbol[i].init(images[i], false, 0, random(100,250));
      // IMAGE  FILTER  LEVEL  OPACITY
    //println("Created " + (i) + " Objects");
     
  }


  
  
}

// DRAW
// ________________________

void draw() {
  background(0);
  
  // Initial Array
  for(int i = 1; i < symbol.length; i++) {
    symbol[i].update();
    symbol[i].display();
  }

  // 
  //stroke(255);
  //line(width/2, 0, width/2, height);

  // Add Frame
   mm.addFrame();
  
}

// ________________________

void keyPressed() {
  if (key == ' ') {
    mm.finish();  // Finish the movie if space bar is pressed!
  }
}

