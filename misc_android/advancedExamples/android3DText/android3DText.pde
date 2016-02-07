// Android Example for Weave Magazine 02.11
//
// android3DText.pde
// Shows the basic use of the 3D Renderer
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Andrés Colubri http://codeanticode.wordpress.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

String[] fontList;
PFont androidFont;
PFont font;
char[] sentence = { 'o', 'n', 'f' , 'o', 'r', 'm', 'a', 't', 'i' , 'v', 'e'};

//-----------------------------------------------------------------------------------------

void setup() {
  size(displayWidth, displayHeight, P3D);
  fontList = PFont.list();
  //println(fontList);
  androidFont= createFont(fontList[4], 30, true); // Sans-Serif Bold
  textFont(androidFont, 96);
}

//-----------------------------------------------------------------------------------------

void draw() {
  println(frameRate);
  background(0);
  smooth();
  translate(width/2, height/2, 0);
  for (int i = 0; i < 11; i++) {  
    rotateY(TWO_PI / 11 + frameCount * PI/5000);
    pushMatrix();
    translate(100, 0, 0);
    text(sentence[i], 0, 0);
    popMatrix();    
  }
} 

//-----------------------------------------------------------------------------------------
// Override the parent (super) Activity class:

void onResume() {
  super.onResume();
  println("RESUMED! (Sketch Entered...)");
}

void onPause() {
  println("PAUSED! (Sketch Exited...)");
  super.onPause();
} 

