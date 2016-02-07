// Android Example for Weave Magazine 02.11
//
// androidDraw.pde
// Shows the basic use of the Touchscreen
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

void setup() {
  background(255);
}
 
//-----------------------------------------------------------------------------------------
 
void draw() {
  println(frameRate);
  strokeWeight(2);
  line(mouseX,mouseY,pmouseX,pmouseY);
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
