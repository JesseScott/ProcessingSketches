// Android Example for Weave Magazine 02.11
//
// androidTypography.pde
// Shows the basic use of Keyboard Input
//
// Written by Cedric Kiefer / Jesse Scott
// www.onformative.com
// 
// Tested on Android 2.2 (Nexus One), Processing 1.2 (0191)
// Android SDK Tools Revision 6, API Level 7

//-----------------------------------------------------------------------------------------

// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

//-----------------------------------------------------------------------------------------

// Screen Data:
float sw, sh;
float ts = 75;
// Font Data:
String[] fontList;
PFont androidFont;
// Keyboard Input
String msg = ""; // Empty String to start

//-----------------------------------------------------------------------------------------

void setup() {
 
 size(screenWidth, screenHeight); // A3D aliases text
 sw = screenWidth; // 480.0 on N1
 sh = screenHeight; // 800.0 on N1 
 
 // Set this so the sketch won't reset as the phone is rotated
 orientation(LANDSCAPE); // Note that this flips sw + sh
 
 // Setup Fonts
 fontList = PFont.list();
 //println(fontList);// Uncomment if you want to see different system options
 androidFont= createFont(fontList[4], ts, true); // Sans-Serif Bold
 textFont(androidFont);
 textMode(MODEL); // SCREEN Mode substantially slows down sketch
} 

//-----------------------------------------------------------------------------------------

void draw() { 
  background(0); // Dark Grey
  //println(frameRate);
  // Create our Bounding Boxes for the Text, and the offset to Center the Text with
  float fieldX = sw * 0.9; // 720 on N1
  float offsetX = fieldX /2;
  float fieldY = sh * 0.9; // 432 on N1
  float offsetY = fieldY /2;

  textAlign(CENTER, CENTER); // Center the Text
  fill(255); // White
  text(msg, sw/2-offsetX, sh/2-offsetY, fieldX, fieldY); // Static Text, centered
}

//-----------------------------------------------------------------------------------------

void keyPressed() {
 if (key != CODED) {
  msg+=key; // Add each key press to the string
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



