// Android Example for Weave Magazine 02.11
//
// androidMultiTouch.pde
// Shows the basic use of MultiTouch Events
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
//
// With Code from Eric Pavey http://www.akeric.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

import android.view.MotionEvent;

//-----------------------------------------------------------------------------------------

String[] fontList;
PFont androidFont;
int circleBaseSize = 256; // change this to make the touch circles bigger\smaller.

//-----------------------------------------------------------------------------------------

void setup() {
  size(displayWidth, displayHeight, P2D);
  // Fix the orientation so the sketch won't reset when rotated.
  orientation(LANDSCAPE);
  stroke(255);
  smooth();
  // Setup Fonts:
  fontList = PFont.list();
  androidFont = createFont(fontList[0], 16, true);
  textFont(androidFont);
  textAlign(LEFT);
}

//-----------------------------------------------------------------------------------------

void draw() {
  println(frameRate);
  background(0);
}

//-----------------------------------------------------------------------------------------

void infoCircle(float x, float y, float siz, int id) {
  // What is drawn on sceen when touched.
  float diameter = circleBaseSize * siz;
  noFill();
  strokeWeight(3);
  ellipse(x, y, diameter, diameter);
  fill(0,255,0);
  ellipse(x, y, 8, 8);
  text( ("ID:"+ id + " " + int(x) + ", " + int(y) ), x-128, y-64);
}

//-----------------------------------------------------------------------------------------
// Override Processing's surfaceTouchEvent, which will intercept all
// screen touch events.  This code only runs when the screen is touched.

public boolean surfaceTouchEvent(MotionEvent me) {
  // Number of places on the screen being touched:
  int numPointers = me.getPointerCount(); // Nexus One only supports Two points...
  for(int i=0; i < numPointers; i++) {
    int pointerId = me.getPointerId(i);
    float x = me.getX(i);
    float y = me.getY(i);
    float siz = me.getSize(i);
    infoCircle(x, y, siz, pointerId);
  }
  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(me);
}
